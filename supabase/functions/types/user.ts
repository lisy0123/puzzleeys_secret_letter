export interface UserData {
    user_id: string;
    auth_user_id: string;
    email: string;
    provider: string;
    created_at: string;
}

export interface PostData {
    id: string;
    puzzle_index?: number;
    title: string;
    content: string;
    color: string;
    receiver_id?: string;
    views: number;
    puzzle_count: number;
    expires_at: string;
}