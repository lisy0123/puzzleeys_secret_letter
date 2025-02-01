import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { PostData, PostQuery } from "../types/user.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";

export class PostRepository {
    static async getGlobalPosts(): Promise<Response | PostData[]> {
        const { data, error } = await supabase.rpc("get_global_posts");
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data;
    }

    static getSubjectPosts(): Promise<Response | PostData[]> {
        return this.fetchPosts("subject_post");
    }

    static getUserPosts(
        user: User,
        table: string
    ): Promise<Response | PostData[]> {
        let condition: PostQuery = {};
        const body = uuidToBase64(user.id);

        if (table == "personal_post") {
            const currentDateUTC = new Date().toISOString();
            condition = {
                receiver_id: body,
                created_at: { lt: currentDateUTC },
            };
        } else if (table == "global_post") {
            condition = { author_id: body };
        }

        return this.fetchPosts(table, condition);
    }

    static async fetchPosts(
        table: string,
        query?: PostQuery
    ): Promise<PostData[] | Response> {
        const queryBuilder = supabase.from(table).select("*");

        if (query != null) {
            Object.entries(query).forEach(([key, value]) => {
                if (key === "created_at") {
                    queryBuilder.filter(key, "lt", value.lt);
                } else {
                    queryBuilder.filter(key, "eq", value);
                }
            });
        }
        queryBuilder.filter("report", "eq", false);

        const { data, error } = await queryBuilder;
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data;
    }

    static async report(table: string, id: string): Promise<Response | void> {
        const { error } = await supabase
            .from(table)
            .update({ report: true })
            .eq("id", id)
            .is("report", false);

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }

    static async deleteGlobalUser(id: string): Promise<Response | void> {
        const { error } = await supabase.rpc("delete_user_posts", {
            id_input: id,
            base_table: "global_post",
            backup_table: "backup_global_post",
        });
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }

    static async post(table: string, body: JSON): Promise<Response | void> {
        const { error } = await supabase.from(table).insert([body]);
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }

    static async postPersonal(body: JSON): Promise<Response | void> {
        const { error } = await supabase.rpc("post_personal", {
            body: body,
        });
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }
}
