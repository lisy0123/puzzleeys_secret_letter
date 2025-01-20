import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { PostData } from "../types/user.ts";
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
        let condition;
        const body = uuidToBase64(user.id);

        if (table == "personal_post") {
            condition = { receiver_id: body };
        } else if (table == "global_post") {
            condition = { author_id: body };
        }

        return this.fetchPosts(table, condition);
    }

    static async fetchPosts(
        table: string,
        query?: { receiver_id?: string; author_id?: string }
    ): Promise<PostData[] | Response> {
        const queryBuilder = supabase.from(table).select("*");

        if (query != null) {
            Object.entries(query).forEach(([key, value]) => {
                queryBuilder.filter(key, "eq", value);
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

    static async deleteGlobalUser(id: string): Promise<Response | PostData[]> {
        const { data, error } = await supabase.rpc("delete_global_user");
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data;
    }
}
