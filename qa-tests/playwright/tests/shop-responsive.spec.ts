import { test, expect } from '@playwright/test';

test.describe('Ana sayfa - yükleme (loading) durumu', () => {
  test('yükleme sonunda skeleton kayboluyor, veri ya da hata durumuna ulaşılıyor', async ({ page }) => {
    await page.goto('/');

    const region = page.getByTestId('featured-products-region');
    await expect(region).toBeVisible();

    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const hasError = await page.getByText('Ürünler yüklenemedi').isVisible();
    const cardCount = await region.locator('.grid > div').count();
    expect(hasError || cardCount > 0).toBeTruthy();
  });
});

test.describe('Masaüstü görünüm', () => {
  test('ürün grid alanı masaüstünde doğru sütun class\'ına sahip (veri varsa)', async ({ page }) => {
    await page.goto('/');
    const region = page.getByTestId('featured-products-region');
    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const gridEl = region.locator('.grid');
    const gridCount = await gridEl.count();
    test.skip(gridCount === 0, 'Backend henüz veri döndürmüyor (hata durumu), grid render edilmedi');

    await expect(gridEl).toHaveClass(/xl:grid-cols-4/);
  });
});