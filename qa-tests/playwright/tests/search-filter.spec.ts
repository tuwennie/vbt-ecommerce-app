import { test, expect } from '@playwright/test';

test.describe("Arama ve filtreleme (gerçek API mekaniği)", () => {
  test("kategori linkine tıklanınca doğru query param gönderiliyor", async ({ page }) => {
    await page.goto('/');
    await page.getByRole('link', { name: 'Ev & Ofis' }).click();
    await expect(page).toHaveURL('/search?category=ev-ofis');
    await expect(page.getByRole('heading', { name: 'Ev & Ofis' })).toBeVisible();
  });

  test("arama kutusu doğru query param ile search sayfasına yönlendiriyor", async ({ page }) => {
    await page.goto('/');
    const searchBox = page.getByRole('searchbox', { name: 'Ürün ara' });
    await searchBox.fill('oak');
    await searchBox.press('Enter');

    await expect(page).toHaveURL('/search?search=oak');
    await expect(page.getByRole('heading', { name: '"oak" için sonuçlar' })).toBeVisible();
  });

  test("siralama degistirilince URL'e sort parametresi ekleniyor", async ({ page }) => {
    await page.goto('/search?category=ev-ofis');
    await page.getByRole('combobox', { name: 'Sıralama ölçütü' }).selectOption('price');
    await expect(page).toHaveURL(/sort=price/);
  });

  test("sonuc bolgesi yukleme bitince veri, bos durum veya hata ile sonuclaniyor", async ({ page }) => {
    await page.goto('/search');

    const region = page.getByTestId('search-results-region');
    await expect(region).toBeVisible();
    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const hasError = await page.getByText('Ürünler yüklenemedi').isVisible();
    const hasEmptyState = await page.getByText('Bu kritere uygun ürün bulunamadı.').isVisible();
    const cardCount = await region.locator('.grid > div').count();

    expect(hasError || hasEmptyState || cardCount > 0).toBeTruthy();
  });

  test("sayfalama tiklaninca URL'e page parametresi ekleniyor (veri varsa)", async ({ page }) => {
    await page.goto('/search');

    const region = page.getByTestId('search-results-region');
    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const pageTwoButton = page.getByRole('button', { name: '2', exact: true });
    const hasPagination = await pageTwoButton.isVisible();
    test.skip(!hasPagination, 'Backend henüz veri döndürmüyor, sayfalama UI görünmedi');

    await pageTwoButton.click();
    await expect(page).toHaveURL(/page=2/);
  });
});