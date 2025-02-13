import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";
import { BarRepository } from "../repositories/bar-repository.ts";
import { BarData } from "../types/user.ts";

export class BarService {
    static getData(user: User): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const resultList = await BarRepository.getData(userId);
                if ("status" in resultList) {
                    return resultList;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    "Get get bar successful.",
                    resultList
                );
            },
        });
    }

    static postData(user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const error = await BarRepository.postData(
                    userId,
                    body as BarData
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post bar data successful.`,
                    null
                );
            },
        });
    }
}
