import { User } from "jsr:@supabase/supabase-js@2";
import { PostService } from "../../services/post-service.ts";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";

export class PostController {
    static getGlobal(_c: Context, _user: User) {
        return ResponseUtils.handleRequest({ callback: PostService.global });
    }
    static getSubject(_c: Context, _user: User) {
        return ResponseUtils.handleRequest({ callback: PostService.subject });
    }
    static getPersonal(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: PostService.user,
            user: user,
            tableOrBody: "personal_post",
        });
    }
    static getGlobalUser(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: PostService.user,
            user: user,
            tableOrBody: "global_post",
        });
    }

    static async postGlobal(c: Context, _user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: PostService.postGlobal,
            tableOrBody: body,
        });
    }
    static async postSubject(c: Context, _user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: PostService.postSubject,
            tableOrBody: body,
        });
    }
    static async postPersonal(c: Context, _user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: PostService.postPersonal,
            tableOrBody: body,
        });
    }

    static postGlobalReport(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.report,
            user: _user,
            tableOrBody: "global_post",
            id: id,
        });
    }
    static postSubjectReport(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.report,
            user: _user,
            tableOrBody: "subject_post",
            id: id,
        });
    }
    static postPersonalReport(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.report,
            user: _user,
            tableOrBody: "personal_post",
            id: id,
        });
    }

    static deleteGlobalUser(c: Context, _user: User) {
        const id = c.req.param("id");
        return ResponseUtils.handleRequest({
            callback: PostService.deleteGlobalUser,
            user: _user,
            only_id: id,
        });
    }
}
