import { uuid } from "https://deno.land/x/uuid@v0.1.2/v4.ts";
import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";

const maskSensitiveData = (
    data: Record<string, unknown>
): Record<string, unknown> => {
    if (typeof data === "object" && data !== null) {
        Object.keys(data).forEach((key) => {
            if (
                typeof data[key] === "string" &&
                key.toLowerCase().includes("email")
            ) {
                data[key] = "***@***.com";
            }
            if (
                typeof data[key] === "string" &&
                (key.toLowerCase().includes("token") ||
                    key.toLowerCase().includes("authorization"))
            ) {
                data[key] = "***";
            }
        });
    }
    return data;
};

const log = (
    type: string,
    timestamp: string,
    requestId: string,
    data: {
        label: string;
        method: string;
        url: string;
        headers: Record<string, string>;
        body: string | null;
        duration?: number;
        status?: number;
    }
) => {
    const logMessage = {
        type,
        timestamp,
        requestId,
        label: data.label,
        method: data.method,
        url: data.url,
        headers: data.headers,
        body: data.body,
        duration: data.duration,
        status: data.status,
    };
    console.log(JSON.stringify(logMessage, null, 2));
};

export const loggingMiddleware = async (
    c: Context,
    next: () => Promise<void>
) => {
    const start = Date.now();
    const timestamp = new Date().toISOString();
    const requestId = uuid();

    try {
        let requestBody: Record<string, unknown> | null = null;
        try {
            requestBody = await c.req.json();
        } catch (_error) {
            requestBody = null;
        }

        const requestHeaders: Record<string, string> = {};
        const headerNames = ["content-type", "authorization"];

        headerNames.forEach((headerKey) => {
            const headerValue = c.req.header(headerKey);
            if (headerValue) {
                requestHeaders[headerKey] = headerValue;
            }
        });

        log("INFO", timestamp, requestId, {
            label: "Incoming Request",
            method: c.req.method,
            url: c.req.url,
            headers: requestHeaders,
            body: requestBody
                ? JSON.stringify(maskSensitiveData(requestBody))
                : null,
        });

        await next();

        const duration = Date.now() - start;

        const responseHeaders: Record<string, string> = {};
        for (const [key, value] of c.res.headers.entries()) {
            responseHeaders[key] = value;
        }

        let responseBody: string | null = null;
        if (c.res.body) {
            if (c.res.body instanceof ReadableStream) {
                responseBody = "[ReadableStream]";
            } else if (typeof c.res.body === "object") {
                responseBody = JSON.stringify(maskSensitiveData(c.res.body));
            } else {
                responseBody = c.res.body as string;
            }
        }

        log("INFO", timestamp, requestId, {
            label: "Outgoing Response",
            method: c.req.method,
            url: c.req.url,
            headers: responseHeaders,
            body: responseBody,
            duration,
            status: c.res.status,
        });
    } catch (error: unknown) {
        const timestamp = new Date().toISOString();
        const errorMessage = (error as Error).message;

        const errorLog = {
            type: "ERROR",
            timestamp,
            requestId,
            message: errorMessage,
            requestInfo: {
                method: c.req.method,
                url: c.req.url,
            },
            environment: Deno.env.get("ENV") || "local",
        };

        console.error(JSON.stringify(errorLog, null, 2));

        c.json({ error: errorMessage }, 500);
    }
};
