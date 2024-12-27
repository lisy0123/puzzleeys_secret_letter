import { createResponse } from "./response/response-format.ts";
import { ResponseCode } from "./response/response-code.ts";
import { SupabaseClient, createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("PROJECT_URL");
const SUPABASE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!SUPABASE_URL || !SUPABASE_KEY) {
    createResponse(
        ResponseCode.SERVER_ERROR,
        "Missing Supabase configuration. Ensure PROJECT_URL and SUPABASE_SERVICE_ROLE_KEY are set.",
        null
    );
}

export const supabase: SupabaseClient = createClient(
    SUPABASE_URL,
    SUPABASE_KEY
);
