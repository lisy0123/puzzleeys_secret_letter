import { Context, Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { uuidToBase64 } from "../../lib/utils/uuid-to-base64.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { AuthService } from "../../services/auth-service.ts";
import { withAuth } from "../middleware/auth-middleware.ts";

const authRouter = new Hono();

async function handleLogin(c: Context, user: User) {
    const body = await c.req.json();
    return ResponseUtils.handleRequest(AuthService.login, user, body);
}
async function handleLogout(c: Context, user: User) {
    const body = await c.req.json();
    return ResponseUtils.handleRequest(AuthService.logout, user, body);
}
async function handleUpsertFcm(c: Context, user: User) {
    const body = await c.req.json();
    return ResponseUtils.handleRequest(AuthService.upsertFcm, user, body);
}

function handleCheckUser() {
    return createResponse(
        ResponseCode.SUCCESS,
        "User verification successful.",
        null
    );
}
function handleMe(_c: Context, user: User) {
    return createResponse(ResponseCode.SUCCESS, "Get user data successful.", {
        user_id: uuidToBase64(user.id),
        created_at: user.created_at,
    });
}

authRouter.post("/login", (c) => withAuth(c, handleLogin));
authRouter.post("/logout", (c) => withAuth(c, handleLogout));
authRouter.post("/upsert_fcm", (c) => withAuth(c, handleUpsertFcm));

authRouter.get("/check_user", (c) => withAuth(c, handleCheckUser));
authRouter.get("/me", (c) => withAuth(c, handleMe));

authRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default authRouter;
