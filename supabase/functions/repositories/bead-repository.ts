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

    static async updateBead(
        field: string,
        id: string
    ): Promise<Response | string> {
        const { data, error } = await supabase
            .from("bead_user_list")
            .update({ [field]: true })
            .eq("id", id)
            .is(field, false)
            .select();

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data[0].color;
    }

    static async updatePost<T>(
        table: string,
        field: string,
        id: string
    ): Promise<Response | boolean | null> {
        const { data, error } = await supabase
            .from(table)
            .update({ [field]: true })
            .eq("id", id)
            .is(field, false)
            .select();

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        if (data.length == 0) {
            return false;
        }
        return true;
    }
}
