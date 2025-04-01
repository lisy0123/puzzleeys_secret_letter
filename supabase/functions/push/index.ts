import { NotificationService } from "../services/push-service.ts";
import { UserNotificationWebhookPayload } from "../types/notification.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { ResponseCode } from "../lib/response/response-code.ts";

Deno.serve(async (req) => {
    try {
        const payload: UserNotificationWebhookPayload = await req.json();
        const result = await NotificationService.handleNotification(
            payload.record
        );

        if (!result.success) {
            return createResponse(
                ResponseCode.NOT_FOUND,
                result.message as string,
                null
            );
        }
        return createResponse(
            ResponseCode.SUCCESS,
            "FCM notifications sent",
            result.results
        );
    } catch (err) {
        console.error("Error processing notification request:", err);
        return createResponse(
            ResponseCode.SERVER_ERROR,
            "Internal Server Error",
            null
        );
    }
});
