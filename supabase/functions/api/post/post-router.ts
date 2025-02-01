import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { PostController } from "./post-controller.ts";
import { withAuth } from "../middleware/auth-middleware.ts";

const postRouter = new Hono();

postRouter.get("/global", (c) => withAuth(c, PostController.getGlobal));
postRouter.get("/subject", (c) => withAuth(c, PostController.getSubject));
postRouter.get("/personal", (c) => withAuth(c, PostController.getPersonal));
postRouter.get("/global_user", (c) => withAuth(c, PostController.getGlobalUser));

postRouter.post("/global", (c) => withAuth(c, PostController.postGlobal));
postRouter.post("/subject", (c) => withAuth(c, PostController.postSubject));
postRouter.post("/personal", (c) => withAuth(c, PostController.postPersonal));

postRouter.post("/global_report/:id", (c) =>
    withAuth(c, PostController.postGlobalReport)
);
postRouter.post("/subject_report/:id", (c) =>
    withAuth(c, PostController.postSubjectReport)
);
postRouter.post("/personal_report/:id", (c) =>
    withAuth(c, PostController.postPersonalReport)
);

postRouter.delete("/global/:id", (c) => withAuth(c, PostController.deleteGlobalUser));

postRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default postRouter;
