import { supabase } from "../lib/supabase-config.ts";

export class NotificationRepository {
    static async getFcmTokens(userId: string): Promise<string[] | null> {
        const { data, error } = await supabase
            .from("fcm_token")
            .select("fcm_token")
            .eq("auth_user_id", userId);

        if (error || !data) {
            console.error("Error fetching FCM tokens:", error);
            return null;
        }
        return data.map((row: { fcm_token: string }) => row.fcm_token);
    }

    static async updateNotificationResult(
        id: string,
        completedAt: string,
        result: { [key: string]: string[] }
    ): Promise<void> {
        const { error } = await supabase
            .from("fcm_notification")
            .update({
                completed_at: completedAt,
                result: JSON.stringify(result),
            })
            .eq("id", id);

        if (error) {
            console.error("Error updating notification result:", error);
            throw error;
        }
    }

    static async deleteFcmTokens(tokens: string[]): Promise<void> {
        const { error } = await supabase
            .from("fcm_token")
            .delete()
            .in("fcm_token", tokens);

        if (error) {
            console.error("Error deleting FCM tokens:", error);
        }
    }
}
