import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { BarService } from "../../services/bar-service.ts";

export class BarController {
    static getPuzzle(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: BarService.getPuzzle,
            user: user,
        });
    }

    static async PostPuzzle(c: Context, user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: BarService.postPuzzle,
            user: user,
            tableOrBody: body,
        });
    }
}
