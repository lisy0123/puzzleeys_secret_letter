import { Context, Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { PostController } from "./post-controller.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { withAuth } from "../middleware/auth-middleware.ts";

const postRouter = new Hono();
const postController = new PostController();

function handleGetGlobal(_c: Context, user: User) {
    return postController.executeFunction("getGlobal", user);
}
function handleGetSubject(_c: Context, user: User) {
    return postController.executeFunction("getSubject", user);
}
function handleGetPersonal(_c: Context, user: User) {
    return postController.executeFunction("getPersonal", user);
}
function handleGetGlobalUser(_c: Context, user: User) {
    return postController.executeFunction("getGlobalUser", user);
}

function handlePostGlobal(_c: Context, user: User) {
    return postController.executeFunction("postGlobal", user);
}
function handlePostSubject(_c: Context, user: User) {
    return postController.executeFunction("postSubject", user);
}
function handlePostPersonal(c: Context, user: User) {
    return postController.executeFunction("postPersonal", user, c.req.param('id'));
}

function handleDeleteGlobalUser(c: Context, user: User) {
    return postController.executeFunction("deleteGlobalUser", user, c.req.param('id'));
}

postRouter.get("/global", (c) => withAuth(c, handleGetGlobal));
postRouter.get("/subject", (c) => withAuth(c, handleGetSubject));
postRouter.get("/personal", (c) => withAuth(c, handleGetPersonal));
postRouter.get("/global_user", (c) => withAuth(c, handleGetGlobalUser));

// TODO: need to add post/delete
postRouter.post("/global", (c) => withAuth(c, handlePostGlobal));
postRouter.post("/subject", (c) => withAuth(c, handlePostSubject));
postRouter.post("/personal/:id", (c) => withAuth(c, handlePostPersonal));

postRouter.delete("/global/:id", (c) => withAuth(c, handleDeleteGlobalUser));

postRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default postRouter;
