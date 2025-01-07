import { Context, Next } from "https://deno.land/x/hono@v4.3.11/mod.ts";

export class LoggingMiddleware {
    static async logger(c: Context, next: Next) {
        const start = Date.now();
        const timestamp = new Date().toISOString();

        try {
            const { requestHeaders, requestBody } =
                await LoggingMiddleware.extractHeadersBody(c);

            LoggingMiddleware.logRequestResponse(
                "INFO",
                timestamp,
                "Incoming Request",
                c.req.method,
                c.req.url,
                requestHeaders,
                requestBody
                    ? JSON.stringify(
                          LoggingMiddleware.maskSensitiveData(requestBody)
                      )
                    : null
            );

            await next();

            const duration = Date.now() - start;
            const responseHeaders: Record<string, string> = {};
            for (const [key, value] of c.res.headers.entries()) {
                responseHeaders[key] = value;
            }
            const clonedResponse = c.res.clone();
            const responseBody = await LoggingMiddleware.processBody(
                clonedResponse.body,
                c.req.method,
                c.req.url
            );

            LoggingMiddleware.logRequestResponse(
                "INFO",
                timestamp,
                "Outgoing Response",
                c.req.method,
                c.req.url,
                responseHeaders,
                responseBody,
                duration
            );
        } catch (error: unknown) {
            const timestamp = new Date().toISOString();
            if (error instanceof Error) {
                LoggingMiddleware.logError(
                    timestamp,
                    c.req.method,
                    c.req.url,
                    error
                );
            } else {
                LoggingMiddleware.logError(timestamp, c.req.method, c.req.url);
            }
            c.json("Internal Server Error", 500);
        }
    }

    static maskSensitiveData(
        data: Record<string, unknown>
    ): Record<string, unknown> {
        if (data && typeof data === "object") {
            Object.keys(data).forEach((key) => {
                if (
                    typeof data[key] === "string" &&
                    key.toLowerCase().includes("authorization")
                ) {
                    data[key] = "***";
                }
            });
        }
        return data;
    }

    static async readStream(stream: ReadableStream): Promise<string> {
        const reader = stream.getReader();
        const chunks: Uint8Array[] = [];
        let done = false;

        while (!done) {
            const { value, done: isDone } = await reader.read();
            if (value) chunks.push(value);
            done = isDone;
        }
        return new TextDecoder().decode(
            new Uint8Array(chunks.flatMap((chunk) => [...chunk]))
        );
    }

    static async processBody(
        body: unknown,
        method: string,
        url: string
    ): Promise<string | null> {
        if (body instanceof ReadableStream) {
            const bodyContent = await LoggingMiddleware.readStream(body);
            const parsedBody = JSON.parse(bodyContent || "{}");

            let result;
            if (
                parsedBody?.result != null &&
                method === "GET" &&
                (url.endsWith("/api/post/global") ||
                    url.endsWith("/api/post/subject") ||
                    url.endsWith("/api/post/personal"))
            ) {
                result = "[Readablestream]";
            } else {
                result = parsedBody?.result;
            }

            return JSON.stringify(
                {
                    code: parsedBody?.code,
                    message: parsedBody?.message,
                    result: result,
                },
                null,
                2
            );
        }
        return body
            ? JSON.stringify(
                  LoggingMiddleware.maskSensitiveData(
                      body as Record<string, unknown>
                  ),
                  null,
                  2
              )
            : null;
    }

    static async extractHeadersBody(c: Context) {
        let requestBody: Record<string, unknown> | null = null;
        try {
            requestBody = await c.req.json();
        } catch (_error) {
            requestBody = null;
        }

        const requestHeaders = ["content-type", "authorization"].reduce(
            (acc, headerKey) => {
                const headerValue = c.req.header(headerKey);
                if (headerValue) acc[headerKey] = headerValue;
                return acc;
            },
            {} as Record<string, string>
        );

        return { requestHeaders, requestBody };
    }

    static logRequestResponse(
        type: string,
        timestamp: string,
        label: string,
        method: string,
        url: string,
        headers: Record<string, string>,
        body: string | null,
        duration?: number
    ) {
        const logMessage = {
            type,
            timestamp,
            label,
            method,
            url,
            headers: LoggingMiddleware.maskSensitiveData(headers),
            body: body ? JSON.parse(body) : null,
            duration,
        };
        console.log(
            JSON.stringify(
                logMessage,
                (key, value) => {
                    if (
                        key === "body" &&
                        typeof value === "object" &&
                        value !== null
                    ) {
                        return LoggingMiddleware.maskSensitiveData(value);
                    }
                    return value;
                },
                2
            )
        );
    }

    static logError(
        timestamp: string,
        method: string,
        url: string,
        error?: Error
    ) {
        const errorLog = {
            type: "ERROR",
            timestamp,
            requestInfo: { method, url },
            message: error ? error.message : "An unknown error occurred",
            stack: error instanceof Error ? error.stack : undefined,
            environment: Deno.env.get("ENV") || "local",
        };
        console.error(JSON.stringify(errorLog, null, 2));
    }
}
