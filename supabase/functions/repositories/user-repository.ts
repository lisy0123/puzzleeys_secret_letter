import { User } from "jsr:@supabase/supabase-js@2";
import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { supabase, } from "./../lib/supabase-config.ts";
import { uuidToBase64 } from "./../lib/utils/uuid-to-base64.ts";
import { UserData } from "../types/user.ts";

export class UserRepository {
    static async insertUser(user: User): Promise<Response | void> {
        const existingUser = await this.getUserWithId(user);
        if (!existingUser) {
            const { error: insertError } = await supabase
                .from("user_list")
                .insert({
                    user_id: uuidToBase64(user.id),
                    email: user.email,
                    auth_user_id: user.id,
                    provider: user.app_metadata?.provider,
                    created_at: user.created_at,
                });

            if (insertError) {
                return createResponse(
                    ResponseCode.SERVER_ERROR,
                    `Error inserting user data into user_list: ${insertError.message}`,
                    null
                );
            }
        }
    }

    static async getUserWithId(user: User): Promise<Response | UserData> {
        const { data, error } = await supabase
            .from("user_list")
            .select("*")
            .eq("auth_user_id", user.id)
            .single();

        if (error && error.code !== "PGRST116") {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data as UserData;
    }

    static async getUserIdWithId(user: User): Promise<Response | string> {
        const data = await this.getUserWithId(user);
        if ("status" in data) {
            return data;
        }
        if (data && (data as UserData).user_id) {
            return (data as UserData).user_id;
        }
        return createResponse(ResponseCode.NOT_FOUND, "No user found.", null);
    }
}