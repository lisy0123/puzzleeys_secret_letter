import { Context, Next } from "https://deno.land/x/hono@v4.3.11/mod.ts";

export class LoggingMiddleware {
    static async logger(c: Context, next: Next) {
        const start = Date.now();
        const timestamp = new Date().toISOString();

        try {
            const { headers: requestHeaders, body: requestBody } =
                await LoggingMiddleware.extractHeadersAndBody(c);

            LoggingMiddleware.log({
                label: "REQUEST",
                timestamp,
                method: c.req.method,
                url: c.req.url,
                headers: LoggingMiddleware.maskSensitiveData(requestHeaders),
                body: requestBody,
            });

            await next();

            const duration = Date.now() - start;
            const { headers: responseHeaders, body: responseBody } =
                await LoggingMiddleware.extractResponseData(c);

            LoggingMiddleware.log({
                label: "RESPONSE",
                timestamp,
                method: c.req.method,
                url: c.req.url,
                headers: responseHeaders,
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

    static maskSensitiveData<T extends Record<string, string>>(
        data: T
    ): Record<string, string> {
        const maskedData = Object.fromEntries(
            Object.entries(data).map(([key, value]) =>
                key.toLowerCase().includes("authorization")
                    ? [key, "***"]
                    : [key, value]
            )
        );
        return maskedData as Record<string, string>;
    }

    static async extractHeadersAndBody(c: Context) {
        const headers = ["content-type", "authorization"].reduce((acc, key) => {
            const value = c.req.header(key);
            if (value) acc[key] = value;
            return acc;
        }, {} as Record<string, string>);

        let body: string | null = null;
        try {
            body = JSON.stringify(await c.req.json());
        } catch {
            body = null;
        }
        return { headers, body };
    }

    static async extractResponseData(c: Context) {
        const headers = Object.fromEntries(c.res.headers.entries());
        let body: string | null = null;

        if (c.res.body && c.res.body instanceof ReadableStream) {
            const clonedResponse = c.res.clone();

            body = await LoggingMiddleware.readStream(
                clonedResponse.body as ReadableStream<Uint8Array>
            );
            Object.defineProperty(c.res, "body", {
                value: clonedResponse.body,
                writable: false,
            });
        } else if (c.res.body !== null) {
            body = JSON.stringify(c.res.body);
        }

        return { headers, body };
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

    static log({
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
        body: string | null;
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
