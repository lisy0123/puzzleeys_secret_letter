import { supabase } from "../lib/supabase-config.ts";
import { PushNotificationParams } from "../types/notification.ts";

export const enqueuePushNotification = async ({
    userId,
    body,
    title,
}: PushNotificationParams) => {
    try {
        const { data: userData, error: userError } = await supabase
            .from("user_list")
            .select("auth_user_id")
            .eq("user_id", userId);

        if (userError) {
            console.error("Error enqueuing push notification:", userError);
            throw userError;
        }

        const authUserId = userData?.[0]?.auth_user_id;

        const { data, error } = await supabase.from("fcm_notification").insert([
            {
                auth_user_id: authUserId,
                body: body || null,
                title: title || null,
            },
        ]);

        if (error) {
            console.error("Error enqueuing push notification:", error);
            throw error;
        }

        return data;
    } catch (error) {
        console.error("Error processing push notification:", error);
        throw error;
    }
};
