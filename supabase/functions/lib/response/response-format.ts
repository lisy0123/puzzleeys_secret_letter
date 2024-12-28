import { ResponseCode } from "./response-code.ts";

export interface ResponseFormat<T extends Record<string, unknown> | null> {
    code: ResponseCode;
    message: string;
    result: T | null;
}

export function createResponse<T extends Record<string, unknown> | null>(
    code: ResponseCode,
    message: string,
    result: T | null
): Response {
    const responseBody: ResponseFormat<T> = { code, message, result };
    return new Response(JSON.stringify(responseBody), { status: code });
}
