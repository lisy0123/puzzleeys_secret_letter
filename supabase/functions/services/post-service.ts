import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { PostRepository } from "../repositories/post-repository.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";

export class PostService {
    static getGlobal(): Promise<Response> {
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

    static getUser(user: User, table: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const posts = await PostRepository.getUserPosts(
                    userId,
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

    static getAllUser(user: User): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const posts = await PostRepository.getAllUserPosts(userId);
                if ("status" in posts) {
                    return posts;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    `Get all user's post successful.`,
                    posts
                );
            },
        });
    }

    static postPost(_user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const list = body as Array<unknown>;
                const table = list[0] as string;
                const postBody = list[1] as JSON;

                const error = await PostRepository.postPost(table, postBody);
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post ${table} successful.`,
                    null
                );
            },
        });
    }

    static updatePost(
        _user: User,
        body: unknown,
        id: unknown
    ): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const list = body as Array<string>;

                const error = await PostRepository.updatePost(
                    list[0],
                    list[1],
                    id as string
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `${list[1]} ${list[0]} successful.`,
                    null
                );
            },
        });
    }

    static deletePost(_user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const list = body as Array<string>;

                const error = await PostRepository.deletePost(list[0], list[1]);
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
