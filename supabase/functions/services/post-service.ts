import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { PostRepository } from "../repositories/post-repository.ts";

export class PostService {
    static global(): Promise<Response> {
        return ResponseUtils.handleRequest(async () => {
            const posts = await PostRepository.getGlobalPosts();
            if ("status" in posts) {
                return posts;
            }

            return createResponse(ResponseCode.SUCCESS, "Login successful.", posts);
        });
    }

    static subject(): Promise<Response> {
        return ResponseUtils.handleRequest(async () => {
            return createResponse(ResponseCode.SUCCESS, "Subject.", {});
        });
    }

    static personal(user: User): Promise<Response> {
        return ResponseUtils.handleRequest(async () => {
            return createResponse(ResponseCode.SUCCESS, "Login successful.", {
                user,
            });
        });
    }
}
