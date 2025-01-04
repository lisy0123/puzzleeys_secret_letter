import { Context, Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { postController } from "./post-controller.ts"
import { authMiddleware } from "../middleware/auth-middleware.ts";
import { User } from "jsr:@supabase/supabase-js@2";

const postRouter = new Hono();

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

const handleGlobal = (_c: Context, user: User) => {
    return postController(user);
};

const handleSubject = (_c: Context, user: User) => {
    return postController(user);
};

const handlePersonal = (_c: Context, user: User) => {
   return postController(user); 
};

postRouter.get("/global", (c) => withAuth(c, handleGlobal));
postRouter.get("/subject", (c) => withAuth(c, handleSubject));
postRouter.get("/personal", (c) => withAuth(c, handlePersonal));

postRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default postRouter;
