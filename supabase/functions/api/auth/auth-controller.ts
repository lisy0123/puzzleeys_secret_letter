import { Context } from "https://deno.land/x/hono@v4.3.11/mod.ts";
import { uuidToBase64 } from "../../lib/utils/uuid-to-base64.ts";
import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseUtils } from "../../lib/response/response-utils.ts";
import { AuthService } from "../../services/auth-service.ts";
import { createResponse } from "../../lib/response/response-format.ts";
import { ResponseCode } from "../../lib/response/response-code.ts";

export class AuthController {
    static async login(c: Context, user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: AuthService.login,
            user: user,
            tableOrBody: body,
        });
    }
    static async logout(c: Context, user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: AuthService.logout,
            user: user,
            tableOrBody: body,
        });
    }
    static async upsertFcm(c: Context, user: User) {
        const body = await c.req.json();
        return ResponseUtils.handleRequest({
            callback: AuthService.upsertFcm,
            user: user,
            tableOrBody: body,
        });
    }

    static propertyRight(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: AuthService.propertyRight,
            user: user,
        });
    }

    static deleteUser(_c: Context, user: User) {
        return ResponseUtils.handleRequest({
            callback: AuthService.deleteUser,
            user: user,
        });
    }

    static checkUser() {
        return createResponse(
            ResponseCode.SUCCESS,
            "User verification successful.",
            null
        );
    }
    static me(_c: Context, user: User) {
        return createResponse(
            ResponseCode.SUCCESS,
            "Get user data successful.",
            {
                user_id: uuidToBase64(user.id),
                created_at: user.created_at,
            }
        );
    }
}
