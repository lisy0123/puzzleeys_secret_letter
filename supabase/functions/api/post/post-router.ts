import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { PostController } from "./post-controller.ts";
import { withAuth } from "../middleware/auth-middleware.ts";

const postRouter = new Hono();
const global = "global_post";
const subject = "subject_post";
const personal = "personal_post";

postRouter.get("/global", (c) => withAuth(c, PostController.getGlobal));
postRouter.get("/subject", (c) => withAuth(c, PostController.getUser, subject));
postRouter.get("/personal", (c) =>
    withAuth(c, PostController.getUser, personal)
);
postRouter.get("/global_user", (c) =>
    withAuth(c, PostController.getUser, global)
);

postRouter.post("/global", (c) => withAuth(c, PostController.postPost, global));
postRouter.post("/subject", (c) =>
    withAuth(c, PostController.postPost, subject)
);
postRouter.post("/personal", (c) =>
    withAuth(c, PostController.postPost, personal)
);

postRouter.post("/global_report/:id", (c) =>
    withAuth(c, PostController.reportPost, global)
);
postRouter.post("/subject_report/:id", (c) =>
    withAuth(c, PostController.reportPost, subject)
);
postRouter.post("/personal_report/:id", (c) =>
    withAuth(c, PostController.reportPost, personal)
);
postRouter.post("/personal_read/:id", (c) =>
    withAuth(c, PostController.readPost)
);

postRouter.delete("/global_delete/:id", (c) =>
    withAuth(c, PostController.deleteGlobalUser)
);

postRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default postRouter;
