import { Context, Next } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { ResponseFormat } from "../../types/user.ts";

export class LoggingMiddleware {
    static async logger(c: Context, next: Next) {
        const start = Date.now();
        const timestamp = new Date().toISOString();

        try {
            const requestBody = await LoggingMiddleware.extractRequestBody(c);

            LoggingMiddleware.log({
                label: "REQUEST",
                timestamp,
                method: c.req.method,
                url: c.req.url,
                headers: LoggingMiddleware.extractHeaders(c),
                body: requestBody,
            });

            await next();

            const duration = Date.now() - start;
            const responseBody = await LoggingMiddleware.extractResponseData(c);

            LoggingMiddleware.log({
                label: "RESPONSE",
                timestamp,
                method: c.req.method,
                url: c.req.url,
                headers: LoggingMiddleware.extractHeaders(c),
                body: responseBody,
                duration,
            });
        } catch (error) {
            LoggingMiddleware.logError(
                timestamp,
                c.req.method,
                c.req.url,
                error as Error
            );
            c.json("Internal Server Error", 500);
        }
    }

    static extractHeaders(c: Context) {
        const headers = ["content-type", "authorization"].reduce((acc, key) => {
            const value = c.req.header(key);
            if (value) acc[key] = value;
            return acc;
        }, {} as Record<string, string>);

        const maskedData = Object.fromEntries(
            Object.entries(headers).map(([key, value]) =>
                key.toLowerCase().includes("authorization")
                    ? [key, "***"]
                    : [key, value]
            )
        );
        return maskedData as Record<string, string>;
    }

    static async extractRequestBody(c: Context) {
        let body: string | null = null;
        try {
            body = JSON.stringify(await c.req.json());
        } catch {
            body = null;
        }
        return body;
    }

    static async extractResponseData<T>(c: Context) {
        let body: string | ResponseFormat<T> | null = null;

        if (c.res.body instanceof ReadableStream) {
            const clonedResponse = c.res.clone();
            const rawBody = await LoggingMiddleware.readStream(
                clonedResponse.body as ReadableStream<Uint8Array>
            );

            try {
                const parsedBody = JSON.parse(rawBody);
                const result =
                    c.req.url.includes("/api/post/global") ||
                    c.req.url.includes("/api/post/subject") ||
                    c.req.url.includes("/api/post/personal")
                        ? "[Readablestream]"
                        : parsedBody.result;
                body = {
                    code: parsedBody.code,
                    message: parsedBody.message,
                    result,
                };
            } catch {
                body = rawBody;
            }
            Object.defineProperty(c.res, "body", {
                value: clonedResponse.body,
                writable: false,
            });
        } else if (c.res.body) {
            try {
                const parsedBody = c.res.body as ResponseFormat<T>;
                body = {
                    code: parsedBody.code,
                    message: parsedBody.message,
                    result: parsedBody.result,
                };
            } catch {
                body = c.res.body;
            }
        }
        return body;
    }

    static async readStream(stream: ReadableStream): Promise<string> {
        const reader = stream.getReader();
        const chunks: Uint8Array[] = [];
        while (true) {
            const { value, done } = await reader.read();
            if (done) break;
            if (value) chunks.push(value);
        }

        const combined = new Uint8Array(
            chunks.reduce((total, chunk) => total + chunk.length, 0)
        );

        let offset = 0;
        for (const chunk of chunks) {
            combined.set(chunk, offset);
            offset += chunk.length;
        }
        return new TextDecoder().decode(combined);
    }

    static log<T>({
        label,
        timestamp,
        method,
        url,
        headers,
        body,
        duration,
    }: {
        label: string;
        timestamp: string;
        method: string;
        url: string;
        headers: Record<string, string>;
        body: string | ResponseFormat<T> | null;
        duration?: number;
    }) {
        const logMessage = {
            label,
            timestamp,
            method,
            url,
            headers,
            body,
            duration,
        };
        console.log(JSON.stringify(logMessage, null, 2));
    }

    static logError(
        timestamp: string,
        method: string,
        url: string,
        error?: Error
    ) {
        const errorLog = {
            label: "ERROR",
            timestamp,
            method,
            url,
            message: error?.message || "An unknown error occurred",
            stack: error?.stack,
            environment: Deno.env.get("ENV") || "local",
        };
        console.error(JSON.stringify(errorLog, null, 2));
    }
}
