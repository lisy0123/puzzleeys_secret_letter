import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { PostService } from "../../services/post-service.ts";
import { ResponseUtils } from "../../lib/response/response-utils.ts";

export class PostController {
    private functionMap: {
        [key: string]: (user: User, id?: unknown) => Promise<Response>;
    } = {};

    constructor() {
        this.functionMap["getGlobal"] = () =>
            ResponseUtils.handleRequest(PostService.global);
        this.functionMap["getSubject"] = () =>
            ResponseUtils.handleRequest(PostService.subject);
        this.functionMap["getPersonal"] = (user: User) =>
            ResponseUtils.handleRequest(PostService.userPost, user, "personal_post");
        this.functionMap["getGlobalUser"] = (user: User) =>
            ResponseUtils.handleRequest(PostService.userPost, user, "global_post");
    }

    public executeFunction(
        action: string,
        user: User,
        id?: unknown
    ): Response | Promise<Response> {
        if (this.functionMap[action]) {
            if (id) {
                return this.functionMap[action](user, id);
            }
            return this.functionMap[action](user);
        } else {
            return createResponse(
                ResponseCode.NOT_FOUND,
                `No function found for function: ${action}`,
                null
            );
        }
    }
}
