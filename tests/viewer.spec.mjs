import { expect, test } from "@playwright/test";

const VIEWER_URL =
    "http://localhost:8683/web/viewer.html?file=compressed.tracemonkey-pldi-09.pdf";

test.describe("PDF.js viewer", () => {
    test("loads and renders the test PDF", async ({ page }) => {
        await page.goto(VIEWER_URL);

        // Wait for the viewer container to be present
        await expect(page.locator("#viewer")).toBeVisible();

        // Wait for at least one page to render (canvas or text layer)
        const firstPage = page.locator('.page[data-page-number="1"]');
        await expect(firstPage).toBeVisible({ timeout: 15_000 });

        // Verify the page count shows the correct number of pages
        const numPages = page.locator("#numPages");
        await expect(numPages).toHaveText(/of.*14/, { timeout: 15_000 });
    });

    test("hides patched UI elements", async ({ page }) => {
        await page.goto(VIEWER_URL);
        await expect(page.locator("#viewer")).toBeVisible();

        // These elements should be hidden by the CSS patch in update.sh
        await expect(page.locator("#presentationMode")).toBeHidden();
        await expect(page.locator("#secondaryOpenFile")).toBeHidden();
        await expect(page.locator("#viewBookmark")).toBeHidden();
    });

    test("can navigate to page 2", async ({ page }) => {
        await page.goto(VIEWER_URL);

        const firstPage = page.locator('.page[data-page-number="1"]');
        await expect(firstPage).toBeVisible({ timeout: 15_000 });

        // Navigate to page 2
        const pageInput = page.locator("#pageNumber");
        await pageInput.fill("2");
        await pageInput.press("Enter");

        const secondPage = page.locator('.page[data-page-number="2"]');
        await expect(secondPage).toBeVisible({ timeout: 10_000 });
    });
});
