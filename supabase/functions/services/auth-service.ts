import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { AuthRepository } from "../repositories/auth-repository.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";

export async function authService(user: User): Promise<Response> {
    try {
        const insertResponse = await AuthRepository.insertUser(user);
        if (insertResponse) {
            return insertResponse;
        }

        return createResponse(ResponseCode.SUCCESS, "Login successful.", {
            user_id: uuidToBase64(user.id),
            created_at: user.created_at,
        });
    } catch (error: unknown) {
        if (error instanceof Error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                error.message,
                null
            );
        }
        if (typeof error === "object" && error !== null && "message" in error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                (error as { message: string }).message,
                null
            );
        }

        return createResponse(
            ResponseCode.SERVER_ERROR,
            "An unknown error occurred.",
            null
        );
    }
}
