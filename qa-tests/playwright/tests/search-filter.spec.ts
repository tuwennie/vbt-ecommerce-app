import { test, expect } from '@playwright/test';

test.describe('Arama ve filtreleme', () => {
  test('kategori linkine tıklanınca doğru query param gönderiliyor', async ({ page }) => {
    await page.goto('/');
    await page.getByRole('link', { name: 'Ev & Ofis' }).click();
    await expect(page).toHaveURL('/search?category=ev-ofis');
    await expect(page.getByRole('heading', { name: 'Ev & Ofis' })).toBeVisible();
  });

  test('arama kutusu doğru query param ile /search\'e yönlendiriyor', async ({ page }) => {
    await page.goto('/');
    const searchBox = page.getByRole('searchbox', { name: 'Ürün ara' });
    await searchBox.fill('oak');
    await searchBox.press('Enter');

    await expect(page).toHaveURL('/search?search=oak');
    await expect(page.getByText('Nordic Oak Dining Table')).toBeVisible({ timeout: 5000 });
  });

  test('sıralama değiştirilince URL\'e ?sort= ekleniyor', async ({ page }) => {
    await page.goto('/search?category=ev-ofis');
    await expect(page.getByText('Nordic Oak Dining Table')).toBeVisible({ timeout: 5000 });

    await page.getByRole('combobox', { name: 'Sıralama ölçütü' }).selectOption('price');
    await expect(page).toHaveURL(/sort=price/);
  });

  test('sayfalama tıklanınca URL\'e ?page= ekleniyor', async ({ page }) => {
    await page.goto('/search?category=ev-ofis');
    await expect(page.getByText('Nordic Oak Dining Table')).toBeVisible({ timeout: 5000 });

    await page.getByRole('button', { name: '2', exact: true }).click();
    await expect(page).toHaveURL(/page=2/);
  });

  test('kriterlere uygun ürün yoksa boş durum mesajı gösteriliyor', async ({ page }) => {
    await page.goto('/search?search=olmayanurun123');
    await expect(page.getByText('Bu kritere uygun ürün bulunamadı.')).toBeVisible({ timeout: 5000 });
  });
});