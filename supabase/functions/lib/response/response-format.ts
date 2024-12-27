import { ResponseCode } from "./response-code.ts";

export interface ResponseFormat<T extends Record<string, any> | null> {
    code: ResponseCode;
    message: string;
    result: T | null;
}

export function createResponse<T extends Record<string, any> | null>(
    code: ResponseCode,
    message: string,
    result: T | null
): Response {
    return new Response(
        JSON.stringify({ code, message, result } as ResponseFormat<T>),
        { status: code }
    );
}
