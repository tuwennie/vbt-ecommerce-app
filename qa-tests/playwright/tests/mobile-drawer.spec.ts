import { test, expect, devices } from '@playwright/test';
import { loginAsAdmin } from './utils/auth';

// Bu dosyadaki testler sadece mobil görünümde anlamlı olduğu için
// kendi içinde bir mobil viewport tanımlıyoruz (masaüstünde sidebar zaten
// her zaman açık, hamburger/backdrop mantığı devreye girmiyor).
test.use({ ...devices['iPhone 13'] });

test.describe('Mobil sidebar (drawer)', () => {
  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
    await page.goto('/admin/dashboard');
  });

  test('varsayılan olarak sidebar kapalı', async ({ page }) => {
    await expect(page.getByRole('link', { name: 'Siparişler', exact: true })).not.toBeInViewport();
  });

  test('hamburger ile sidebar açılıyor', async ({ page }) => {
    await page.getByRole('button', { name: 'Menüyü aç' }).click();
    await expect(page.getByRole('link', { name: 'Siparişler', exact: true })).toBeInViewport();
  });

  test('kapat butonuyla sidebar kapanıyor', async ({ page }) => {
    await page.getByRole('button', { name: 'Menüyü aç' }).click();
    await page.getByRole('button', { name: 'Menüyü kapat' }).click();
    await expect(page.getByRole('link', { name: 'Siparişler', exact: true })).not.toBeInViewport();
  });

  test('nav linkine tıklanınca sidebar otomatik kapanıyor', async ({ page }) => {
    await page.getByRole('button', { name: 'Menüyü aç' }).click();
    await page.getByRole('link', { name: 'Ürünler', exact: true }).click();

    await expect(page).toHaveURL('/admin/products');
    await expect(page.getByRole('link', { name: 'Ürünler', exact: true })).not.toBeInViewport();
  });

  test('arka plana (backdrop) tıklanınca sidebar kapanıyor', async ({ page }) => {
    await page.getByRole('button', { name: 'Menüyü aç' }).click();
    await expect(page.getByRole('link', { name: 'Siparişler', exact: true })).toBeInViewport();

    // Backdrop, sidebar'ın sağındaki karartılmış alan — sağ üst köşeye tıklıyoruz.
    await page.mouse.click(350, 300);

    await expect(page.getByRole('link', { name: 'Siparişler', exact: true })).not.toBeInViewport();
  });
});