import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { UserRepository } from "../repositories/user-repository.ts";
import { User } from "jsr:@supabase/supabase-js@2";

export class UserService {
    static async getUser(user: User): Promise<Response> {
        try {
            const userData = await UserRepository.getUserWithId(user);
            if (userData instanceof Response) {
                return userData;
            }

            return createResponse(ResponseCode.SUCCESS, "Get user data successful.", {
                user_id: userData.user_id,
                created_at: userData.created_at,
            });
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
