import { encodeBase64 } from "jsr:@std/encoding/base64";

export function uuidToBase64(uuid: string): string {
    const buffer = new Uint8Array(16);
    for (let i = 0, j = 0; i < uuid.length; i++) {
        if (uuid[i] !== "-") {
            buffer[j++] = parseInt(uuid.slice(i, i + 2), 16);
            i++;
        }
    }
    return encodeBase64(buffer);
}
