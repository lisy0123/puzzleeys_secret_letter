import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { BarData } from "../types/user.ts";

export class BarRepository {
    static async getData(userId: string): Promise<Response | BarData> {
        const resultList = await this.getDataWithId(userId);
        if (!resultList) {
            const { data, error } = await supabase
                .from("bar_user_list")
                .insert([{ user_id: userId }])
                .select("puzzle, date");

            if (error) {
                return createResponse(
                    ResponseCode.SERVER_ERROR,
                    `Error inserting user data into user_list: ${error.message}`,
                    null
                );
            }
            return data[0];
        }
        return resultList;
    }

    static async getDataWithId(
        userId: string
    ): Promise<Response | undefined | BarData> {
        const { data, error } = await supabase
            .from("bar_user_list")
            .select("puzzle, date")
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
        return data[0];
    }

    static async postData(userId: string, body: BarData): Promise<Response | void> {
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
