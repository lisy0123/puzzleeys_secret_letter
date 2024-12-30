import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { UserRepository } from "../repositories/user-repository.ts";
import { User } from "jsr:@supabase/supabase-js@2";

export class AuthService {
    static async login(user: User): Promise<Response> {
        try {
            const insertResponse = await UserRepository.insertUser(user);
            if (insertResponse) {
                return insertResponse;
            }

            return createResponse(
                ResponseCode.SUCCESS,
                "Login successful.",
                null
            );
        } catch (error: unknown) {
            if (error instanceof Error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR,
                    error.message,
                    null
                );
            }
            if (
                typeof error === "object" &&
                error !== null &&
                "message" in error
            ) {
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
}
