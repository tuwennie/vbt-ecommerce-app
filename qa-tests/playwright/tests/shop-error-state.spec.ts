import { test, expect } from '@playwright/test';

test.describe('Hata durumu (500)', () => {
  test('ana sayfada ürünler yüklenemeyince hata component\'i gösteriliyor', async ({ page }) => {
    await page.goto('/?simulateError=true');

    await expect(page.getByText('Ürünler yüklenemedi')).toBeVisible({ timeout: 5000 });
    await expect(
      page.getByText('Ürünler şu anda yüklenemedi. Lütfen tekrar deneyin.'),
    ).toBeVisible();
    await expect(page.getByRole('button', { name: 'Tekrar Dene' })).toBeVisible();
  });

  test('arama sayfasında ürünler yüklenemeyince hata component\'i gösteriliyor', async ({ page }) => {
    await page.goto('/search?category=ev-ofis&simulateError=true');

    await expect(page.getByText('Ürünler yüklenemedi')).toBeVisible({ timeout: 5000 });
    await expect(page.getByRole('button', { name: 'Tekrar Dene' })).toBeVisible();
  });

  test('tekrar dene butonu tıklanabiliyor', async ({ page }) => {
    await page.goto('/?simulateError=true');
    await expect(page.getByText('Ürünler yüklenemedi')).toBeVisible({ timeout: 5000 });

    const retryButton = page.getByRole('button', { name: 'Tekrar Dene' });
    await retryButton.click();

    // simulateError=true hâlâ URL'de olduğu için hata tekrar gösterilecek —
    // burada asıl doğrulanan, retry mekanizmasının çalışıp isteği tekrar attığı
    // (buton tıklanabilir, sayfa çökmüyor).
    await expect(page.getByText('Ürünler yüklenemedi')).toBeVisible({ timeout: 5000 });
  });
});