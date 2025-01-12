import { createResponse } from "./response-format.ts";
import { ResponseCode } from "./response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";

export class ResponseUtils {
    static async handleRequest<T>(
        callback: (
            user: User,
            table: string
        ) => Promise<Response> | (() => Promise<Response>),
        user?: User,
        table?: string
    ): Promise<Response> {
        try {
            if (table) {
                return await (
                    callback as (user: User, table: string) => Promise<Response>
                )(user!, table);
            } else if (user) {
                return await (callback as (user: User) => Promise<Response>)(
                    user
                );
            } else {
                return await (callback as () => Promise<Response>)();
            }
        } catch (error: unknown) {
            return this.handleError(error);
        }
    }

    static handleError(error: unknown): Response {
        if (error instanceof Error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Server error: ${error.message}`,
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
            "Server error: Unknown error.",
            null
        );
    }
}
