import { JWT } from "npm:google-auth-library@9";
import {
    firebaseClientEmail,
    firebasePrivateKey,
    firebaseProjectID,
} from "../environments.ts";
import { NotificationRepository } from "../repositories/push-repository.ts";
import { UserNotificationRecord } from "../types/notification.ts";

let cachedAccessToken: string | null = null;
let tokenExpirationTime: number | null = null;

const getAccessToken = async (): Promise<string> => {
    const now = Date.now();
    if (cachedAccessToken && tokenExpirationTime && now < tokenExpirationTime) {
        return cachedAccessToken;
    }

    const jwtClient = new JWT({
        email: firebaseClientEmail,
        key: firebasePrivateKey,
        scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });

    const tokens = await jwtClient.authorize();
    cachedAccessToken = tokens.access_token!;
    tokenExpirationTime = tokens.expiry_date!;
    return cachedAccessToken;
};

const sendNotification = async (
    fcmToken: string,
    record: UserNotificationRecord,
    accessToken: string
): Promise<{ fcmToken: string; status: string }> => {
    try {
        const res = await fetch(
            `https://fcm.googleapis.com/v1/projects/${firebaseProjectID}/messages:send`,
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${accessToken}`,
                },
                body: JSON.stringify({
                    message: {
                        token: fcmToken,
                        notification: {
                            title: record.title,
                            body: record.body,
                        },
                    },
                }),
            }
        );

        const resData = await res.json();
        if (res.status < 200 || res.status > 299) {
            const errorCode = resData.error?.status || "UNKNOWN_ERROR";
            console.error("Error sending FCM message:", errorCode);
            return { fcmToken, status: errorCode };
        }
        return { fcmToken, status: "SUCCESS" };
    } catch (err) {
        console.error("Error sending FCM message:", err);
        return { fcmToken, status: "SEND_ERROR" };
    }
};

export const NotificationService = {
    async handleNotification(record: UserNotificationRecord) {
        const completedAt = new Date().toISOString();
        const fcmTokens = await NotificationRepository.getFcmTokens(
            record.auth_user_id
        );

        if (!fcmTokens) {
            await NotificationRepository.updateNotificationResult(
                record.id,
                completedAt,
                { NOT_EXIST_USER: [] }
            );
            return { success: false, message: "No FCM tokens found" };
        }

        const accessToken = await getAccessToken();
        const results = await Promise.all(
            fcmTokens.map((token) =>
                sendNotification(token, record, accessToken)
            )
        );

        const resultSummary: { [key: string]: string[] } = { SUCCESS: [] };
        results.forEach(({ fcmToken, status }) => {
            if (status === "SUCCESS") {
                resultSummary.SUCCESS.push(fcmToken);
            } else {
                if (!resultSummary[status]) resultSummary[status] = [];
                resultSummary[status].push(fcmToken);
            }
        });

        await NotificationRepository.updateNotificationResult(
            record.id,
            completedAt,
            resultSummary
        );
        return { success: true, results };
    },
};
