import { User } from "jsr:@supabase/supabase-js@2";
import { ResponseCode } from "../lib/response/response-code.ts";
import { createResponse } from "../lib/response/response-format.ts";
import { supabase } from "../lib/supabase-config.ts";
import { PostData } from "../types/user.ts";
import { uuidToBase64 } from "../lib/utils/uuid-to-base64.ts";

interface PostQuery {
    order?: "views";
    ascending?: boolean;
    id_neq?: string[];
    receiver_id?: string;
}

export class PostRepository {
    static async getGlobalPosts(): Promise<Response | PostData[]> {
        const allPosts = await this.fetchPosts("global_post", {}, 101);
        if (this.isErrorResponse(allPosts)) {
            return allPosts;
        }
        if (allPosts.length <= 100) {
            return allPosts;
        }

        const lowViewPosts = await this.fetchPosts(
            "global_post",
            { order: "views", ascending: true },
            30
        );
        if (this.isErrorResponse(lowViewPosts)) {
            return lowViewPosts;
        }

        const remainingPosts = await this.fetchPosts("global_post", {
            id_neq: lowViewPosts.map((post) => post.id),
        });
        if (this.isErrorResponse(remainingPosts)) {
            return remainingPosts;
        }

        const randomPosts = this.getRandomPosts(remainingPosts, 70);
        return [...lowViewPosts, ...randomPosts];
    }

    static async getSubjectPosts(): Promise<Response | PostData[]> {
        const posts = await this.fetchPosts("subject_post", {});
        return posts;
    }

    static async getPersonalPosts(user: User): Promise<Response | PostData[]> {
        const posts = await this.fetchPosts("global_post", {
            receiver_id: uuidToBase64(user.id),
        });
        return posts;
    }

    static async fetchPosts(
        table: string,
        query: PostQuery,
        limit?: number
    ): Promise<PostData[] | Response> {
        const queryBuilder = supabase.from(table).select("*");

        if (query.order === "views") {
            queryBuilder.order("views", { ascending: query.ascending ?? true });
        }
        if (query.id_neq) {
            queryBuilder.not("id", "in", query.id_neq);
        }

        Object.entries(query).forEach(([key, value]) => {
            if (key !== "order" && key !== "ascending" && key !== "id_neq") {
                queryBuilder.filter(key, "eq", value);
            }
        });

        if (limit) {
            queryBuilder.limit(limit);
        }

        const { data, error } = await queryBuilder;
        if (error) {
            return createResponse(
                ResponseCode.SERVER_ERROR,
                `Database query failed: ${error.message}`,
                null
            );
        }
        return data;
    }

    static getRandomPosts(posts: PostData[], n: number): PostData[] {
        return posts.sort(() => Math.random() - 0.5).slice(0, n);
    }

    static isErrorResponse(
        response: PostData[] | Response
    ): response is Response {
        return (
            "status" in response && "message" in response && "data" in response
        );
    }
}
