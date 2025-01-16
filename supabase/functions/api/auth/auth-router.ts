import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { withAuth } from "../middleware/auth-middleware.ts";
import { AuthController } from "./auth-controller.ts";

const authRouter = new Hono();

authRouter.post("/login", (c) => withAuth(c, AuthController.login));
authRouter.post("/logout", (c) => withAuth(c, AuthController.logout));
authRouter.post("/upsert_fcm", (c) => withAuth(c, AuthController.upsertFcm));

authRouter.get("/check_user", (c) => withAuth(c, AuthController.checkUser));
authRouter.get("/me", (c) => withAuth(c, AuthController.me));

authRouter.delete("/delete_user", (c) => withAuth(c, AuthController.deleteUser));

authRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default authRouter;
