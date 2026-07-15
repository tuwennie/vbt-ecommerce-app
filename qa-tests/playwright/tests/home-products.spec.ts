import { test, expect } from '@playwright/test';

test.describe('Ana sayfa - ürün listeleme', () => {
  test('öne çıkan ürünler yükleniyor ve grid olarak render ediliyor', async ({ page }) => {
    await page.goto('/');

    const region = page.getByTestId('featured-products-region');
    await expect(region).toBeVisible();

    // Mock istek ~700ms sürüyor, gerçek ürün kartları görününceye kadar bekle.
    await expect(page.getByText('SonicFlow Wireless Headphones')).toBeVisible({ timeout: 5000 });

    const cards = region.locator('.grid > div');
    await expect(cards).toHaveCount(4);
  });

  test('her üründe sepete ekle butonu var', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByText('SonicFlow Wireless Headphones')).toBeVisible({ timeout: 5000 });

    const addToCartButtons = page.getByRole('button', { name: 'Sepete Ekle' });
    await expect(addToCartButtons).toHaveCount(4);
  });

  test('"Tümünü Gör" linki /search adresine gidiyor', async ({ page }) => {
    await page.goto('/');
    await page.getByRole('link', { name: /Tümünü Gör/ }).click();
    await expect(page).toHaveURL('/search');
  });
});