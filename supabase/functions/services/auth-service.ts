import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { supabase } from "./../lib/supabase-config.ts";
import { authenticateWithSupabase } from "./../repositories/auth-repository.ts";
import { insertUserIfNeeded } from "./../repositories/user-repository.ts";
import { uuidToBase64 } from "./../lib/utils/uuid-to-base64.ts";
import { User } from "jsr:@supabase/supabase-js@2";

export class AuthService {
    static async logout(): Promise<Response> {
        try {
            const { error } = await supabase.auth.signOut();
            if (error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR, `Logout failed: ${error.message}`, null
                );
            }
            return createResponse(ResponseCode.SUCCESS, "Logout successful.", null);
        } catch (err: unknown) {
            if (err instanceof Error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR,
                    `An exception occurred during logout: ${err.message}`,
                    null
                );
            }
            return createResponse(
                ResponseCode.SERVER_ERROR, "An unknown error occurred during logout.", null
            );
        }
    }

    static async login(accessToken: string, idToken: string): Promise<Response> {
        try {
            const authResult = await authenticateWithSupabase(accessToken, idToken);
            if ("status" in authResult) {
                return authResult;
            }

            const user = authResult as User;
            const insertResponse = await insertUserIfNeeded(user);
            if (insertResponse) {
                return insertResponse;
            }

            return createResponse(
                ResponseCode.SUCCESS,
                "Login successful.",
                {user_id: uuidToBase64(user.id)}
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
