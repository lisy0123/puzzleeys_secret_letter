import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";
import { supabase } from "../lib/supabase-config.ts";

export class UserRepository {
    static async upsertFCM(
        authId: string,
        fcmToken: string
    ): Promise<Response | void> {
        const { error: upsertError } = await supabase
            .from("fcm_token")
            .upsert(
                { auth_user_id: authId, fcm_token: fcmToken },
                { onConflict: "fcm_token" }
            );

        if (upsertError) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error upserting FCM token: ${upsertError.message}`,
                null
            );
        }
    }

    static async deleteFCM(
        authId: string,
        fcmToken: string
    ): Promise<Response | void> {
        const { error: deleteError } = await supabase
            .from("fcm_token")
            .delete()
            .eq("auth_user_id", authId)
            .eq("fcm_token", fcmToken);

        if (deleteError) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Error deleting FCM token: ${deleteError.message}`,
                null
            );
        }
    }
}