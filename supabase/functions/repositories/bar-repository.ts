import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";

export class BarRepository {
    static async getPuzzle(userId: string): Promise<Response | string> {
        const puzzleNum = await this.getPuzzleWithId(userId);
        if (!puzzleNum) {
            const { data, error } = await supabase
                .from("bar_user_list")
                .insert([{ user_id: userId }])
                .select("puzzle");

            if (error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR,
                    `Error inserting user data into user_list: ${error.message}`,
                    null
                );
            }
            return data[0].puzzle;
        }
        return puzzleNum;
    }

    static async getPuzzleWithId(
        userId: string
    ): Promise<Response | string | undefined> {
        const { data, error } = await supabase
            .from("bar_user_list")
            .select("puzzle")
            .eq("user_id", userId);

        if (error && error.code !== "PGRST116") {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        if (!data || data.length === 0) {
            return;
        }
        return data[0].puzzle;
    }

    static async postPuzzle(
        userId: string,
        body: { puzzle: number }
    ): Promise<Response | void> {
        const { error } = await supabase
            .from("bar_user_list")
            .update(body)
            .eq("user_id", userId);

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }
}
