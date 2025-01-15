import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { ResponseFormat } from "../../../types/user.ts";

export class Extract {
    static maskedData(data: Record<string, string>) {
        const keysToMask = ["authorization", "fcm_token"];
        const maskedData = Object.fromEntries(
            Object.entries(data).map(([key, value]) =>
                keysToMask.some((maskKey) =>
                    key.toLowerCase().includes(maskKey)
                )
                    ? [key, "***"]
                    : [key, value]
            )
        );
        return maskedData as Record<string, string>;
    }

    static extractHeaders(c: Context) {
        const headers = ["content-type", "authorization"].reduce((acc, key) => {
            const value = c.req.header(key);
            if (value) acc[key] = value;
            return acc;
        }, {} as Record<string, string>);
        return this.maskedData(headers);
    }

    static async extractRequestBody(c: Context) {
        let body: Record<string, string> | null = null;
        try {
            body = this.maskedData(await c.req.json());
        } catch {
            body = null;
        }
        return body;
    }

    static async extractResponseData<T>(c: Context) {
        let body: string | ResponseFormat<T> | null = null;

        if (c.res.body instanceof ReadableStream) {
            const clonedResponse = c.res.clone();
            const rawBody = await this.readStream(
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
}