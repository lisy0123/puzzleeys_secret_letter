export const firebaseClientEmail = Deno.env.get("FB_CLIENT_EMAIL")!;
export const firebasePrivateKey = Deno.env
    .get("FB_PRIVATE_KEY")!
    .replace(/\\n/g, "\n");
export const firebaseProjectID = Deno.env.get("FB_PROJECT_ID")!;
