import { defineConfig } from "@playwright/test";

export default defineConfig({
    testDir: "./tests",
    timeout: 30_000,
    retries: 0,
    use: {
        browserName: "chromium",
        headless: true,
    },
    webServer: {
        command: "npx serve . -l 8683",
        port: 8683,
        reuseExistingServer: !process.env.CI,
    },
});
