import { Context, Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { authController } from "./auth-controller.ts";
import { authMiddleware } from "../middleware/auth-middleware.ts";
import { uuidToBase64 } from "../../lib/utils/uuid-to-base64.ts";
import { User } from "jsr:@supabase/supabase-js@2";

const authRouter = new Hono();

const withAuth = async (
    c: Context,
    handler: (c: Context, user: User) => Response | Promise<Response>
) => {
    const user = await authMiddleware(c);
    if (user instanceof Response) {
        return user;
    }
    return handler(c, user);
};

const handleLogin = (_c: Context, user: User) => {
    return authController(user);
};

const handleCheckUser = () => {
    return createResponse(
        ResponseCode.SUCCESS,
        "User verification successful.",
        null
    );
};

const handleMe = (_c: Context, user: User) => {
    return createResponse(ResponseCode.SUCCESS, "Get user data successful.", {
        user_id: uuidToBase64(user.id),
        created_at: user.created_at,
    });
};

authRouter.post("/login", (c) => withAuth(c, handleLogin));
authRouter.get("/check_user", (c) => withAuth(c, handleCheckUser));
authRouter.get("/me", (c) => withAuth(c, handleMe));

authRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default authRouter;