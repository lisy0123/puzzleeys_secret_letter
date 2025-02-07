import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { BeadData } from "../types/user.ts";

export class BeadRepository {
    static async getUser(userId: string): Promise<Response | BeadData[]> {
        const { data, error } = await supabase
            .from("bead_user_list")
            .select("*")
            .filter("user_id", "eq", userId)
            .filter("report", "eq", false)
            .order("created_at", { ascending: true });

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data;
    }

    static async postUser(body: JSON): Promise<Response | void> {
        const { error } = await supabase.from("bead_user_list").insert([body]);
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
    }
}
