import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { LoginService } from "./login-service.ts";

export async function handleAuthRequest(
    req: Request,
    isLogin: boolean
): Promise<Response> {
    try {
        if (isLogin) {
            const authHeader = req.headers.get("authorization");
            if (!authHeader || !authHeader.startsWith("Bearer ")) {
                return createResponse(
                    ResponseCode.UNAUTHORIZED,
                    "Unauthorized headers.",
                    null
                );
            }

            const tokens = authHeader.split(" ")[1].split(",");
            const accessToken = tokens[0];
            const idToken = isLogin ? tokens[1] : null;
            if (!accessToken || (isLogin && !idToken)) {
                return createResponse(
                    ResponseCode.INVALID_ARGUMENTS,
                    "Missing tokens. Ensure both access_token and id_token are provided.",
                    null
                );
            }

            return await LoginService.login(accessToken, idToken!);
        } else {
            return await LoginService.logout();
        }
    } catch (error: any) {
        return createResponse(
            ResponseCode.SERVER_ERROR,
            `Server error: ${error.message || "Unknown error."}`,
            null
        );
    }
}
