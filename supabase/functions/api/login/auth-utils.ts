import { User } from "jsr:@supabase/supabase-js@2";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { supabase } from "./../../lib/supabase-config.ts";

export async function authenticateWithSupabase(
    accessToken: string,
    idToken: string
): Promise<User> {
    const { data: response, error } = await supabase.auth.signInWithIdToken({
        provider: "google",
        access_token: accessToken,
        token: idToken,
    });

    if (error || !response?.user) {
        return createResponse(
            ResponseCode.INVALID_ARGUMENTS,
            "User authentication failed.",
            null
        );
    }

    return response.user;
}
