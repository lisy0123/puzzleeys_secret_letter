import { ResponseCode } from "../lib/response/response-code.ts";

export interface ResponseFormat<T> {
    code: ResponseCode;
    message: string;
    result: T | null;
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
    parent_post_type?: string;
    parent_post_color?: string;
    read?: boolean;
}

export interface UserData {
    index: string;
    id: string;
    title: string;
    content: string;
    color: string;
    post_type: string;
    created_at: string;
}

export interface BeadData {
    index: string;
    id: string;
    title: string;
    color: string;
    post_type: string;
    created_at: string;
}

export interface BarData {
    puzzle?: number;
    dia?: number;
    date?: string;
}