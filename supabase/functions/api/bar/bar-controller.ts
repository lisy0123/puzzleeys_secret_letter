import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { BarService } from "../../services/bar-service.ts";

export class BarController {
    static getData(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: BarService.getData,
            user: user,
        });
    }

    static async postData(c: Context, user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: BarService.postData,
            user: user,
            tableOrBody: body,
        });
    }
}
