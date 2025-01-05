import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { AuthRepository } from "../repositories/auth-repository.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";
import { ResponseUtils } from "../lib/response/response-utils.ts";

export function authService(user: User): Promise<Response> {
    return ResponseUtils.handleRequest(async () => {
        const insertResponse = await AuthRepository.insertUser(user);
        if (insertResponse) {
            return insertResponse;
        }

        return createResponse(ResponseCode.SUCCESS, "Login successful.", {
            user_id: uuidToBase64(user.id),
            created_at: user.created_at,
        });
    });
}
