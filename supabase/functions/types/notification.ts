export interface UserNotificationRecord {
    id: string;
    auth_user_id: string;
    title: string | null;
    body: string | null;
}

export interface UserNotificationWebhookPayload {
    type: "INSERT";
    table: string;
    record: UserNotificationRecord;
    schema: "public";
}

export interface PushNotificationParams {
    userId: string;
    body?: string;
    title?: string;
}
