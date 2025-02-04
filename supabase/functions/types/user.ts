import { ResponseCode } from "../lib/response/response-code.ts";

export interface ResponseFormat<T> {
    code: ResponseCode;
    message: string;
    result: T | null;
}

export interface UserData {
    user_id: string;
    auth_user_id: string;
    email: string;
    provider: string;
    created_at: string;
}

export interface PostQuery {
    receiver_id?: string;
    author_id?: string;
    created_at?: { lt: string };
}

export interface PostData {
    id: string;
    puzzle_index?: number;
    title: string;
    content: string;
    color: string;
    author_id?: string;
    receiver_id?: string;
    sender_id?: string;
    created_at: string;
}