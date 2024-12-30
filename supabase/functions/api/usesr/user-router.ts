import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { UserController } from "./user-controller.ts";
import { authMiddleware } from "../middleware/auth-middleware.ts";

const authRouter = new Hono();

authRouter.get("/me", async (c) => {
    const user = await authMiddleware(c);
    if (user instanceof Response) {
        return user;
    }
    return UserController(user);
});

authRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default authRouter;
