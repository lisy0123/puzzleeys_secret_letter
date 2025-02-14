import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { BarData } from "../types/user.ts";

export class BarRepository {
    static async getData(userId: string): Promise<Response | BarData> {
        const { data, error } = await supabase.rpc("get_bar_user", {
            user_id: userId,
        });
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error getting bar data: ${error.message}`,
                null
            );
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
