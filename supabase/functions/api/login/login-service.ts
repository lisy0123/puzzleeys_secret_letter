import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { supabase } from "./../../lib/supabase-config.ts";
import { authenticateWithSupabase } from "./auth-utils.ts";
import { insertUserIfNeeded } from "./user-utils.ts";

export class LoginService {
    static async logout(): Promise<void> {
        try {
            const { error } = await supabase.auth.signOut();
            if (error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR,
                    `Logout failed: ${error.message}`,
                    null
                );
            }
            return createResponse(
                ResponseCode.SUCCESS,
                "Successfully logged out.",
                null
            );
        } catch (err) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `An exception occurred during logout: ${err}`,
                null
            );
        }
    }

    static async login(
        accessToken: string,
        idToken: string
    ): Promise<Response> {
        try {
            const user = await authenticateWithSupabase(accessToken, idToken);
            const insertResponse = await insertUserIfNeeded(user);
            if (insertResponse) {
                return insertResponse;
            }

            return createResponse(ResponseCode.SUCCESS, "Login successful.", {
                id: user.id,
                email: user.email,
            });
        } catch (error: any) {
            return createResponse(
                error.code || ResponseCode.SERVER_ERROR,
                error.message || "An unknown error occurred.",
                null
            );
        }
    }
}
