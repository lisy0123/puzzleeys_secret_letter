import { serve } from "https://deno.land/std@0.186.0/http/server.ts";
import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { handleAuthRequest } from "./login/auth-request-handler.ts";

serve(async (req: Request) => {
    try {
        if (req.url.endsWith("/api/login") && req.method === "POST") {
            return await handleAuthRequest(req, true);
        }
        if (req.url.endsWith("/api/logout") && req.method === "POST") {
            return await handleAuthRequest(req, false);
        }

        return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
    } catch (error: unknown) {
        if (error instanceof Error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Internal Server Error: ${error.message}`,
                null
            );
        }
        return createResponse(
            ResponseCode.SERVER_ERROR,
            "Internal Server Error",
            null
        );
    }
});
