import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";
import { BarRepository } from "../repositories/bar-repository.ts";

export class BarService {
    static getPuzzle(user: User): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const puzzle = await BarRepository.getPuzzle(userId);
                if (puzzle instanceof createResponse) {
                    return puzzle;
                }
                return createResponse(
                    ResponseCode.SUCCESS,
                    "Get user's bead successful.",
                    { puzzle: puzzle }
                );
            },
        });
    }
    static postPuzzle(user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const userId = uuidToBase64(user.id);

                const error = await BarRepository.postPuzzle(
                    userId,
                    body as { puzzle: number }
                );
                if (error) return error;

                return createResponse(
                    ResponseCode.SUCCESS,
                    `Post into bead successful.`,
                    null
                );
            },
        });
    }
}
