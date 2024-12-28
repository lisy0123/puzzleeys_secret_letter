import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { AuthService } from "./../../services/auth-service.ts";
import { UserService } from "./../../services/user-service.ts";

export async function AuthController(
    req: Request,
    isLogin: boolean,
    isExist: boolean,
): Promise<Response> {
    try {
        if (isLogin) {
            const authHeader = req.headers.get("authorization");
            if (!authHeader || !authHeader.startsWith("Bearer ")) {
                return createResponse(ResponseCode.UNAUTHORIZED, "Unauthorized headers.", null);
            }

            const tokens = authHeader.split(" ")[1].split(",");
            if (isExist) {
                if (!tokens) {
                     return createResponse(
                        ResponseCode.INVALID_ARGUMENTS,
                        "Missing user id. Ensure user_id is provided.",
                        null
                    );
                }
                return await UserService.checkUser(tokens[0]);
            } else {
                const accessToken = tokens[0];
                const idToken = tokens[1];
                if (!accessToken || !idToken) {
                    return createResponse(
                        ResponseCode.INVALID_ARGUMENTS,
                        "Missing tokens. Ensure both access_token and id_token are provided.",
                        null
                    );
                }
                return await AuthService.login(accessToken, idToken);
            }
        } else {
            return await AuthService.logout();
        }
    } catch (error: unknown) {
        if (error instanceof Error) {
            return createResponse(
                ResponseCode.SERVER_ERROR, `Server error: ${error.message}`, null
            );
        } else {
            return createResponse(
                ResponseCode.SERVER_ERROR, "Server error: Unknown error.", null
            );
        }
    }
}