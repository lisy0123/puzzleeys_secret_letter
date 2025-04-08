import { supabase } from "../lib/supabase-config.ts";

export const enqueuePushNotification = async (
    userId: string,
    body?: string | null,
    title?: string | null
) => {
    try {
        const { error } = await supabase.rpc("enqueue_push_notification", {
            p_user_id: userId,
            p_body: body || null,
            p_title: title || null,
        });
        if (error) {
            console.error("Error enqueuing push notification:", error);
            throw error;
        }
    } catch (error) {
        console.error("Error processing push notification:", error);
        throw error;
    }
};
