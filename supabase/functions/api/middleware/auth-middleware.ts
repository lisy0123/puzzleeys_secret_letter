import { Context, HonoRequest } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "../../lib/response/response-format.ts";
import { ResponseCode } from "../../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { supabase } from "../../lib/supabase-config.ts";

export async function withAuth(
    c: Context,
    handler: (c: Context, user: User) => Response | Promise<Response>
) {
    const token = AuthMiddleware.header(c.req);
    if (token instanceof Response) {
        return token;
    }
    const user = await AuthMiddleware.user(token);
    if ("status" in user) {
        return user;
    }
    return handler(c, user);
}

class AuthMiddleware {
    static header(req: HonoRequest): Response | string {
        const authHeader = req.header("authorization");
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            return createResponse(
                ResponseCode.UNAUTHORIZED,
                "Unauthorized headers.",
                null
            );
        }

        const token = authHeader.split(" ")[1].split(",");
        if (!token || token.length !== 1) {
            return createResponse(
                ResponseCode.INVALID_ARGUMENTS,
                "Missing token. Ensure token is provided.",
                null
            );
        }
        return token[0];
    }

    static async user(jwt: string): Promise<Response | User> {
        const { data: userData, error: userError } =
            await supabase.auth.getUser(jwt);
        if (userError) {
            return createResponse(
                ResponseCode.UNAUTHORIZED,
                "Invalid or expired JWT",
                null
            );
        }

        const user = userData?.user;
        if (!user) {
            return createResponse(
                ResponseCode.UNAUTHORIZED,
                "No authenticated user found",
                null
            );
        }
        return user;
    }
}
