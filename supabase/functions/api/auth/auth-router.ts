import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { AuthController } from "./auth-controller.ts";

export const AuthRouter = async (req: Request) => {
    if (req.method === "POST") {
        if (req.url.endsWith("/login")) {
            return await AuthController(req, true, false);
        }
        if (req.url.endsWith("/logout")) {
            return await AuthController(req, false, false);
        }
        if (req.url.endsWith("/check_user")) {
            return await AuthController(req, true, true);
        }
    }
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
};