import { User } from "jsr:@supabase/supabase-js@2";
import { PostService } from "../../services/post-service.ts";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";

export class PostController {
    static getGlobal(_c: Context, _user: User) {
        return ResponseUtils.handleRequest({ callback: PostService.getGlobal });
    }
    static getUser(_c: Context, user: User, postType?: string) {
        return ResponseUtils.handleRequest({
            callback: PostService.getUser,
            user: user,
            tableOrBody: postType,
        });
    }

    static async postPost(c: Context, _user: User, postType?: string) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: PostService.postPost,
            tableOrBody: [postType, body],
        });
    }

    static reportPost(c: Context, _user: User, postType?: string) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.updatePost,
            tableOrBody: [postType, "report"],
            id: id,
        });
    }

    static readPost(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.updatePost,
            tableOrBody: ["personal_post", "read"],
            id: id,
        });
    }

    static deleteGlobalUser(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.deleteGlobalUser,
            only_id: id,
        });
    }
}
