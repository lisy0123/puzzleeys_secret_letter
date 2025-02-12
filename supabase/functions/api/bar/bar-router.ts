import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { createResponse } from "./../../lib/response/response-format.ts";
import { ResponseCode } from "./../../lib/response/response-code.ts";
import { withAuth } from "../middleware/auth-middleware.ts";
import { BarController } from "./bar-controller.ts";

const barRouter = new Hono();

barRouter.get("/puzzle", (c) => withAuth(c, BarController.getPuzzle));
barRouter.post("/puzzle", (c) => withAuth(c, BarController.PostPuzzle));

barRouter.all("/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

export default barRouter;
