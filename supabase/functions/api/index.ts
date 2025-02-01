import { Hono } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { serve } from "https://deno.land/std@0.186.0/http/server.ts";
import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import authRouter from "./auth/auth-router.ts";
import postRouter from "./post/post-router.ts";
import { LoggingMiddleware } from "./middleware/logging-middleware.ts";

const app = new Hono();

app.use(LoggingMiddleware.logger);

app.basePath("/api").route("/auth", authRouter);
app.basePath("/api").route("/post", postRouter);

app.all("/api/*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});
app.all("*", () => {
    return createResponse(ResponseCode.NOT_FOUND, "Not Found", null);
});

serve(app.fetch);