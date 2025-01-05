import { ResponseCode } from "./response-code.ts";

interface ResponseFormat<T> {
    code: ResponseCode;
    message: string;
    result: T | null;
}

export function createResponse<T>(
    code: ResponseCode,
    message: string,
    result: T | null
): Response {
    const responseBody: ResponseFormat<T> = { code, message, result };
    return new Response(JSON.stringify(responseBody), { status: code });
}
