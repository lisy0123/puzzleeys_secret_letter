import { ResponseFormat } from "../../../types/user.ts";

export class GetLabel {
    static getLabel(
        responseBody: string | ResponseFormat<unknown> | null
    ): string {
        return this.isResponseFormat(responseBody)
            ? this.getLabelFromCode(responseBody.code)
            : "[ UNKNOWN ]";
    }

    static isResponseFormat(
        responseBody: unknown
    ): responseBody is ResponseFormat<unknown> {
        return (
            typeof responseBody === "object" &&
            responseBody !== null &&
            "code" in responseBody
        );
    }

    static getLabelFromCode(code?: number): string {
        if (code === undefined) return "[ UNKNOWN ]";
        if (code < 300) return "[ SUCCESS ]";
        if (code < 500) return "[ CLIENT ERROR ]";
        if (code >= 500) return "[ SERVER ERROR ]";
        return "[ OTHER ]";
    }
}