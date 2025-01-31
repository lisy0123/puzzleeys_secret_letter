import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { PostRepository } from "../repositories/post-repository.ts";

export class PostService {
    static global(): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const posts = await PostRepository.getGlobalPosts();
                if ("status" in posts) {
                    return posts;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    "Get global posts successful.",
                    posts
                );
            },
        });
    }

    static subject(): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const posts = await PostRepository.getSubjectPosts();
                if ("status" in posts) {
                    return posts;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    "Get subject posts successful.",
                    posts
                );
            },
        });
    }

    static user(user: User, table: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const posts = await PostRepository.getUserPosts(
                    user,
                    table as string
                );
                if ("status" in posts) {
                    return posts;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    `Get ${table}s successful.`,
                    posts
                );
            },
        });
    }

    static postGlobal(_user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const error = await PostRepository.post(
                    "global_post",
                    body as JSON
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post global successful.`,
                    null,
                );
            },
        });
    }

    static postSubject(_user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const error = await PostRepository.post(
                    "subject_post",
                    body as JSON
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post global successful.`,
                    null
                );
            },
        });
    }

    static postPersonal(_user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const error = await PostRepository.postPersonal(
                    body as JSON
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post global successful.`,
                    null
                );
            },
        });
    }

    static report(_user: User, table: unknown, id: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const error = await PostRepository.report(
                    table as string,
                    id as string
                );
                if (error) return error;
                
                return createResponse(
                    ResponseCode.SUCCESS,
                    `Report ${table} post successful.`,
                    null
                );
            },
        });
    }

    static deleteGlobalUser(_user: User, id: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const error = await PostRepository.deleteGlobalUser(
                    id as string
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Delete user's global post successful.`,
                    null
                );
            },
        });
    }
}
