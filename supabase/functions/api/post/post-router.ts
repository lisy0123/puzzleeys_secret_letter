import { Context, Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { PostController } from "./post-controller.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { withAuth } from "../middleware/auth-middleware.ts";

const postRouter = new Hono();
const postController = new PostController();

function handleGlobal(_c: Context, user: User) {
    return postController.executeFunction("global", user);
}

function handleSubject(_c: Context, user: User) {
    return postController.executeFunction("subject", user);
}

function handlePersonal(_c: Context, user: User) {
    return postController.executeFunction("subject", user);
}

postRouter.get("/global", (c) => withAuth(c, handleGlobal));
postRouter.get("/subject", (c) => withAuth(c, handleSubject));
postRouter.get("/personal", (c) => withAuth(c, handlePersonal));

postRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default postRouter;
