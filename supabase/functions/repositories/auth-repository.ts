import { User } from "jsr:@supabase/supabase-js@2";
import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";
import { supabase, } from "../lib/supabase-config.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";

export class AuthRepository {
    static async insertUser(user: User): Promise<Response | void> {
        const { error } = await supabase.rpc("get_user", {
            user_id: uuidToBase64(user.id),
            email: user.email,
            auth_user_id: user.id,
            provider: user.app_metadata?.provider,
            created_at: user.created_at,
        });
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error getting/inserting user data: ${error.message}`,
                null
            );
        }
    }

    static async propertyRight(
        authId: string,
    ): Promise<Response | void> {
        const { error } = await supabase
            .from("user_list")
            .update({ property_right: false })
            .eq("auth_user_id", authId);

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error upserting user's property right: ${error.message}`,
                null
            );
        }
    }

    static async deleteUser(authId: string): Promise<Response | void> {
        const { error } = await supabase.auth.admin.deleteUser(authId);
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }
}