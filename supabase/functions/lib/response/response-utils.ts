import { createResponse } from "./response-format.ts";
import { ResponseCode } from "./response-code.ts";
import { User } from "jsr:@supabase/supabase-js@2";

export class ResponseUtils {
    static async handleRequest<T>(params: {
        callback: (
            user: User,
            table?: string,
            id?: string
        ) => Promise<Response> | Response | (() => Promise<Response>);
        user?: User;
        tableOrBody?: unknown;
        id?: string;
        only_id?: string;
    }): Promise<Response> {
        const { callback, user, tableOrBody, id, only_id } = params;

        try {
            if (only_id) {
                return await (
                    callback as (user: User, id: string) => Promise<Response>
                )(user!, only_id);
            }
            if (id) {
                return await(
                    callback as (
                        user: User,
                        tableOrBody: unknown,
                        id: string
                    ) => Promise<Response>
                )(user!, tableOrBody, id as string);
            }
            if (tableOrBody) {
                return await (
                    callback as (
                        user: User,
                        tableOrBody: unknown
                    ) => Promise<Response>
                )(user!, tableOrBody);
            }
            if (user) {
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
