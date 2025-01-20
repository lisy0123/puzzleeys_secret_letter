import { createResponse } from "./../lib/response/response-format.ts";
import { ResponseCode } from "./../lib/response/response-code.ts";
import { AuthRepository } from "../repositories/auth-repository.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";
import { ResponseUtils } from "../lib/response/response-utils.ts";
import { UserRepository } from "../repositories/user-repository.ts";

export class AuthService {
    static extractFcmToken(body: unknown): string | null {
        return typeof body === "object" && body !== null && "fcm_token" in body
            ? ((body as Record<string, unknown>).fcm_token as string)
            : null;
    }

    static handleFcmTokenRequest(
        user: User,
        body: unknown,
        action: (userId: string, fcmToken: string) => Promise<Response>
    ): Promise<Response> | Response {
        const fcmToken = AuthService.extractFcmToken(body);
        if (!fcmToken) {
            return createResponse(
                ResponseCode.INVALID_ARGUMENTS,
                "Invalid body structure: fcm_token is missing or not a string.",
                null
            );
        }
        return action(user.id, fcmToken);
    }

    static login(user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: () =>
                AuthService.handleFcmTokenRequest(
                    user,
                    body,
                    async (userId, fcmToken) => {
                        const upsertResponse = await UserRepository.upsertFCM(
                            userId,
                            fcmToken
                        );
                        if (upsertResponse) return upsertResponse;

                        const insertResponse = await AuthRepository.insertUser(
                            user
                        );
                        if (insertResponse) return insertResponse;

                        return createResponse(
                            ResponseCode.SUCCESS,
                            "Login and FCM token upsert successful.",
                            {
                                user_id: uuidToBase64(user.id),
                                created_at: user.created_at,
                            }
                        );
                    }
                ),
        });
    }

    static logout(user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: () =>
                AuthService.handleFcmTokenRequest(
                    user,
                    body,
                    async (userId, fcmToken) => {
                        const deleteResponse = await UserRepository.deleteFCM(
                            userId,
                            fcmToken
                        );
                        if (deleteResponse) return deleteResponse;

                        return createResponse(
                            ResponseCode.SUCCESS,
                            "FCM token deletion successful.",
                            null
                        );
                    }
                ),
        });
    }

    static upsertFcm(user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: () =>
                AuthService.handleFcmTokenRequest(
                    user,
                    body,
                    async (userId, fcmToken) => {
                        const upsertResponse = await UserRepository.upsertFCM(
                            userId,
                            fcmToken
                        );
                        if (upsertResponse) return upsertResponse;

                        return createResponse(
                            ResponseCode.SUCCESS,
                            "FCM token upsert successful.",
                            null
                        );
                    }
                ),
        });
    }

    static deleteUser(user: User): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const withdrawResponse = await AuthRepository.deleteUser(user);
                if (withdrawResponse) return withdrawResponse;

                return createResponse(
                    ResponseCode.SUCCESS,
                    "User deletion successful.",
                    null
                );
            },
        });
    }
}
