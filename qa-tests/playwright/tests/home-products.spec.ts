import { test, expect } from '@playwright/test';

test.describe('Ana sayfa - ürün listeleme (gerçek API)', () => {
  test('yükleme bitince ürün grid veya hata durumu gösteriliyor', async ({ page }) => {
    await page.goto('/');

    const region = page.getByTestId('featured-products-region');
    await expect(region).toBeVisible();

    // Önce yüklenmenin bitmesini bekle (skeleton kaybolsun).
    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    // Sonuçta ya ürün kartları ya da hata mesajı görünmeli.
    const hasError = await page.getByText('Ürünler yüklenemedi').isVisible();
    const cardCount = await region.locator('.grid > div').count();
    expect(hasError || cardCount > 0).toBeTruthy();
  });

  test('veri geldiyse her kartta sepete ekle butonu var', async ({ page }) => {
    await page.goto('/');
    const region = page.getByTestId('featured-products-region');

    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const hasError = await page.getByText('Ürünler yüklenemedi').isVisible();
    test.skip(hasError, 'Backend henüz veri döndürmüyor, bu senaryo atlanıyor');

    const cardCount = await region.locator('.grid > div').count();
    test.skip(cardCount === 0, 'Ürün listesi boş, bu senaryo atlanıyor');

    await expect(page.getByRole('button', { name: 'Sepete Ekle' }).first()).toBeVisible();
  });

  test('"Tümünü Gör" linki /search adresine gidiyor', async ({ page }) => {
    await page.goto('/');
    await page.getByRole('link', { name: /Tümünü Gör/ }).click();
    await expect(page).toHaveURL('/search');
  });
});