import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { authController } from "./auth-controller.ts";
import { authMiddleware } from "../middleware/auth-middleware.ts";
import { uuidToBase64 } from "../../lib/utils/uuid-to-base64.ts";

const authRouter = new Hono();

authRouter.post("/login", async (c) => {
    const user = await authMiddleware(c);
    if (user instanceof Response) {
        return user;
    }
    return authController(user);
});

authRouter.get("/check_user", async (c) => {
    const user = await authMiddleware(c);
    if (user instanceof Response) {
        return user;
    }
    return createResponse(
        ResponseCode.SUCCESS,
        "User verification successful.",
        null
    );
});

authRouter.get("/me", async (c) => {
    const user = await authMiddleware(c);
    if (user instanceof Response) {
        return user;
    }
    return createResponse(ResponseCode.SUCCESS, "Get user data successful.", {
        user_id: uuidToBase64(user.id),
        created_at: user.created_at,
    });
});

authRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default authRouter;