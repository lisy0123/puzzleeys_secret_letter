import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { withAuth } from "../middleware/auth-middleware.ts";
import { BeadController } from "./bead-controller.ts";

const beadRouter = new Hono();

beadRouter.get("/user", (c) => withAuth(c, BeadController.getUser));
beadRouter.post("/user", (c) => withAuth(c, BeadController.postUser));

beadRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default beadRouter;
