import { test, expect } from '@playwright/test';
import { loginAsAdmin } from './utils/auth';

test.describe('Sidebar navigasyonu', () => {
  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
    await page.goto('/admin/dashboard');
  });

  const links: { label: string; url: string }[] = [
    { label: 'Siparişler', url: '/admin/orders' },
    { label: 'Ürünler', url: '/admin/products' },
    { label: 'Kategoriler', url: '/admin/categories' },
    { label: 'Müşteriler', url: '/admin/customers' },
    { label: 'Raporlar', url: '/admin/reports' },
    { label: 'Ayarlar', url: '/admin/settings' },
  ];

  for (const link of links) {
    test(`"${link.label}" linkine tıklanınca ${link.url} adresine gidiyor`, async ({ page }) => {
      await page.getByRole('link', { name: link.label, exact: true }).click();
      await expect(page).toHaveURL(link.url);
    });
  }

  test('logo tıklanınca dashboard\'a dönüyor', async ({ page }) => {
    await page.getByRole('link', { name: 'Siparişler', exact: true }).click();
    await expect(page).toHaveURL('/admin/orders');

    await page.getByRole('link', { name: 'ShopSwift Admin' }).click();
    await expect(page).toHaveURL('/admin/dashboard');
  });

  test('aktif sayfa sidebar\'da vurgulanıyor', async ({ page }) => {
    await page.getByRole('link', { name: 'Ürünler', exact: true }).click();
    await expect(page.getByRole('link', { name: 'Ürünler', exact: true })).toHaveClass(/bg-secondary/);
  });
});