import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { authService } from "../../services/auth-service.ts";
import { User } from "jsr:@supabase/supabase-js@2";

export async function postController(user: User): Promise<Response> {
    try {
        return await authService(user);
    } catch (error: unknown) {
        if (error instanceof Error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Server error: ${error.message}`,
                null
            );
        } else {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                "Server error: Unknown error.",
                null
            );
        }
    }
}
