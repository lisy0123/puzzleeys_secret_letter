import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";
import { supabase } from "../lib/supabase-config.ts";

export class UserRepository {
    static async upsertFCM(
        userId: string,
        fcmToken: string
    ): Promise<Response | void> {
        const { error: upsertError } = await supabase
            .from("fcm_token")
            .upsert(
                { auth_user_id: userId, fcm_token: fcmToken },
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
        userID: string,
        fcmToken: string
    ): Promise<Response | void> {
        const { error: deleteError } = await supabase
            .from("fcm_token")
            .delete()
            .eq("auth_user_id", userID)
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