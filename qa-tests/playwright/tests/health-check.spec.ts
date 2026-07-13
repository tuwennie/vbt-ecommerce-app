import { test, expect } from '@playwright/test';

test('health check - site açılıyor mu', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('body')).toBeVisible();
});