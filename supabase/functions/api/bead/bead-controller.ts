import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { AuthService } from "../../services/auth-service.ts";

export class BeadController {
    static async user(c: Context, user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: AuthService.login,
            user: user,
            tableOrBody: body,
        });
    }
}
