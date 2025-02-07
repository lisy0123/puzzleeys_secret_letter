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
        action: (authId: string, fcmToken: string) => Promise<Response>
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

    private static async processFcmAction(
        user: User,
        fcmToken: string,
        isLogin: boolean
    ): Promise<Response> {
        const upsertResponse = await UserRepository.upsertFCM(
            user.id,
            fcmToken
        );
        if (upsertResponse) return upsertResponse;

        if (isLogin) {
            const insertResponse = await AuthRepository.insertUser(user);
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

        return createResponse(
            ResponseCode.SUCCESS,
            "FCM token upsert successful.",
            null
        );
    }

    static processFcmRequest(
        user: User,
        body: unknown,
        isLogin: boolean
    ): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: () =>
                AuthService.handleFcmTokenRequest(
                    user,
                    body,
                    async (_authId, fcmToken) => {
                        return await AuthService.processFcmAction(
                            user,
                            fcmToken,
                            isLogin
                        );
                    }
                ),
        });
    }

    static login(user: User, body: unknown): Promise<Response> {
        return AuthService.processFcmRequest(user, body, true);
    }

    static upsertFcm(user: User, body: unknown): Promise<Response> {
        return AuthService.processFcmRequest(user, body, false);
    }

    static logout(user: User, body: unknown): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: () =>
                AuthService.handleFcmTokenRequest(
                    user,
                    body,
                    async (authId, fcmToken) => {
                        const deleteResponse = await UserRepository.deleteFCM(
                            authId,
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

    static deleteUser(user: User): Promise<Response> {
        return ResponseUtils.handleRequest({
            callback: async () => {
                const withdrawResponse = await AuthRepository.deleteUser(
                    user.id
                );
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
