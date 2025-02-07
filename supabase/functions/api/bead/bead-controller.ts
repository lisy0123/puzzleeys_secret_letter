import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { BeadService } from "../../services/bead-service.ts";

export class BeadController {
    static getUser(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: BeadService.getUser,
            user: user,
        });
    }

    static async postUser(c: Context, _user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: BeadService.postUser,
            tableOrBody: body,
        });
    }
}
