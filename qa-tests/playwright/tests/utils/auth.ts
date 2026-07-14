import type { Page } from '@playwright/test';

export async function loginAsAdmin(page: Page) {
  await page.goto('/admin');
  const origin = new URL(page.url()).origin;
  await page.context().addCookies([
    { name: 'access_token', value: 'mock-access-token', url: origin },
  ]);
}