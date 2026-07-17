import { test, expect, devices } from '@playwright/test';

test.use({ ...devices['iPhone 13'] });

test.describe('Mobil görünüm', () => {
  test('sidebar varsayılan kapalı, hamburger ile açılıyor', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByRole('link', { name: 'Ev & Ofis' })).not.toBeInViewport();

    await page.getByRole('button', { name: 'Menüyü aç' }).click();
    await expect(page.getByRole('link', { name: 'Ev & Ofis' })).toBeInViewport();
  });

  test('ürün grid alanı mobilde tek sütun class\'ına sahip (veri varsa)', async ({ page }) => {
    await page.goto('/');
    const region = page.getByTestId('featured-products-region');

    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const gridEl = region.locator('.grid');
    const gridCount = await gridEl.count();
    test.skip(gridCount === 0, 'Backend henüz veri döndürmüyor (hata durumu), grid render edilmedi');

    await expect(gridEl).toHaveClass(/grid-cols-1/);
  });
});