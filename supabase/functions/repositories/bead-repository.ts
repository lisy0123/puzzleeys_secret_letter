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
                `Error getting user's bead data: ${error.message}`,
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
                `Error posting bead data: ${error.message}`,
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
            .select("color");

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error updating bead: ${error.message}`,
                null
            );
        }
        return data[0].color;
    }

    static async updatePost(
        table: string,
        field: string,
        id: string
    ): Promise<Response | boolean> {
        const { error, count } = await supabase
            .from(table)
            .update({ [field]: true }, { count: "exact" })
            .eq("id", id)
            .is(field, false);

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error updating bead data: ${error.message}`,
                null
            );
        }
        return (count ?? 0) > 0;
    }
    
    static async deletePost(index: string): Promise<Response | void> {
        const { error } = await supabase
            .from("bead_user_list")
            .delete()
            .eq("index", index);

        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error deleting bead data: ${error.message}`,
                null
            );
        }
    }
}
