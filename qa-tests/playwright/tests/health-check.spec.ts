import { test, expect } from '@playwright/test';

test('ana sayfa acilip yukleniyor', async ({ page }) => {
  const response = await page.goto('/');
  expect(response?.status()).toBeLessThan(400);
  await expect(page.locator('body')).toBeVisible();
});