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

    static reportPost(c: Context, _user: User, postType?: string) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: BeadService.updatePost,
            tableOrBody: [postType, "report"],
            id: id,
        });
    }

    static deletePost(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: BeadService.deletePost,
            only_id: id,
        });
    }
}
