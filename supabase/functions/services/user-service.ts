import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { supabase } from "./../lib/supabase-config.ts";

export class UserService {
    static async checkUser(user_id: string): Promise<Response> {
        try {
            const { data: existingUser, error } = await supabase
                .from("user_list")
                .select()
                .eq("user_id", user_id)
                .single();

            if (error && error.code !== "PGRST116") {
                return createResponse(
                    ResponseCode.SERVER_ERROR, `Database query failed: ${error.message}`, null
                );
            }

            if (!existingUser) {
                return createResponse(
                    ResponseCode.INVALID_ARGUMENTS, "No User found in the database.", null
                );
            }
            return createResponse(
                ResponseCode.SUCCESS,
                "User verification successful.",
                {exists: 'Y'}
            );
        } catch (error: unknown) {
            if (error instanceof Error) {
                return createResponse(ResponseCode.SERVER_ERROR, error.message, null);
            }
            if (typeof error === "object" && error !== null && "message" in error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR, (error as { message: string }).message, null
                );
            }
            return createResponse(ResponseCode.SERVER_ERROR, "An unknown error occurred.", null);
        }
    }
}
