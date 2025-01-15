import { Context, Next } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { ResponseFormat } from "../../types/user.ts";
import { GetLabel } from "../../lib/utils/logging-utils/get-label.ts";
import { Extract } from "../../lib/utils/logging-utils/extract.ts";

export class LoggingMiddleware {
    static async logger(c: Context, next: Next) {
        const start = Date.now();
        const timestamp = new Date().toISOString();

        try {
            const requestHeader = Extract.extractHeaders(c);
            const requestBody = await Extract.extractRequestBody(c);

            LoggingMiddleware.log({
                label: "[ REQUEST ]",
                timestamp,
                method: c.req.method,
                url: c.req.url,
                headers: requestHeader,
                body: requestBody,
            });

            await next();

            const duration = Date.now() - start;
            const responseHeader = Extract.extractHeaders(c);
            const responseBody = await Extract.extractResponseData(c);
            const responseLabel = GetLabel.getLabel(responseBody);

            LoggingMiddleware.log({
                label: responseLabel,
                timestamp,
                method: c.req.method,
                url: c.req.url,
                headers: responseHeader,
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
        body: Record<string, string> | string | ResponseFormat<T> | null;
        duration?: number;
    }) {
        const extractedUrl = url.includes(".com") ? url.split(".com")[1] : null;
        const logMessage = {
            label,
            timestamp,
            method,
            url: extractedUrl,
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
        const extractedUrl = url.includes(".com") ? url.split(".com")[1] : null;
        const errorLog = {
            label: "[ ERROR ]",
            timestamp,
            method,
            url: extractedUrl,
            message: error?.message || "An unknown error occurred",
        };
        console.error(JSON.stringify(errorLog, null, 2));
    }
}
