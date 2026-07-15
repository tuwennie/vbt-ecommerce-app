import { test, expect } from '@playwright/test';

test.describe('Ana sayfa - yükleme (loading) durumu', () => {
  test('skeleton önce görünüyor, sonra gerçek ürünlerle değişiyor', async ({ page }) => {
    await page.goto('/');

    const region = page.getByTestId('featured-products-region');
    await expect(region.locator('.animate-pulse').first()).toBeVisible();

    await expect(page.getByText('SonicFlow Wireless Headphones')).toBeVisible({ timeout: 5000 });
    await expect(region.locator('.animate-pulse')).toHaveCount(0);
  });
});

test.describe('Masaüstü görünüm', () => {
  test('ürün grid\'i masaüstünde 4 sütun class\'ına sahip', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByText('SonicFlow Wireless Headphones')).toBeVisible({ timeout: 5000 });

    const region = page.getByTestId('featured-products-region');
    const gridEl = region.locator('.grid');
    await expect(gridEl).toHaveClass(/xl:grid-cols-4/);
  });
});