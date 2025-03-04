import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { PostData, BeadData, PostQuery } from "../types/user.ts";

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

    static getUserPosts(
        userId: string,
        table: string
    ): Promise<Response | PostData[]> {
        if (table == "subject_post") {
            return this.fetchPosts(table);
        }

        let condition: PostQuery = {};

        if (table == "personal_post") {
            const currentDateUTC = new Date().toISOString();
            condition = {
                receiver_id: userId,
                created_at: { lt: currentDateUTC },
            };
        }

        return this.fetchPosts(table, condition);
    }

    static async fetchPosts(
        table: string,
        query?: PostQuery
    ): Promise<PostData[] | Response> {
        const queryBuilder = supabase
            .from(table)
            .select("*")
            .filter("report", "eq", false);

        if (query) {
            Object.entries(query).forEach(([key, value]) => {
                if (key === "created_at") {
                    queryBuilder.filter(key, "lt", value.lt);
                } else {
                    queryBuilder.filter(key, "eq", value);
                }
            });
        }

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

    static async getAllUserPosts(id: string): Promise<Response | BeadData[]> {
        const { data, error } = await supabase.rpc("get_all_user_posts", {
            user_id: id,
        });
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data;
    }

    static async postPost(table: string, body: JSON): Promise<Response | void> {
        let error;

        if (table === "personal_post") {
            const { error: rpcError } = await supabase.rpc("post_personal", {
                body: body,
            });
            error = rpcError;
        } else {
            const { error: insertError } = await supabase
                .from(table)
                .insert([body]);
            error = insertError;
        }
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }

    static async updatePost(
        table: string,
        field: string,
        id: string
    ): Promise<Response | void> {
        const { error } = await supabase
            .from(table)
            .update({ [field]: true })
            .eq("id", id)
            .is(field, false);

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }

    static async deletePost(table: string, id: string): Promise<Response | void> {
        const { error } = await supabase.rpc("delete_user_posts", {
            id_input: id,
            base_table: table,
            backup_table: `backup_${table}`,
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
