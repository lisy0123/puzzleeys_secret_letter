import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";
import { BeadRepository } from "../repositories/bead-repository.ts";

export class BeadService {
    static getUser(user: User): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const posts = await BeadRepository.getUser(userId);
                if ("status" in posts) {
                    return posts;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    "Get user's bead successful.",
                    posts
                );
            },
        });
    }
    static postUser(_user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const error = await BeadRepository.postUser(body as JSON);
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post into bead successful.`,
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
                
                const beadColor = await BeadRepository.updateBead(
                    list[1],
                    id as string
                );
                if (beadColor instanceof Response) {
                    return beadColor;
                } 

                const isExist = await BeadRepository.updatePost(
                    list[0],
                    list[1],
                    id as string
                );
                if (isExist instanceof Response) {
                    return isExist;
                }

                return createResponse(
                    ResponseCode.SUCCESS,
                    `${list[1]} ${list[0]} & bead_user_list successful.`,
                    { beadColor: beadColor, isExist: isExist }
                );
            },
        });
    }
}
