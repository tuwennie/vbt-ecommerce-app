import { test, expect } from '@playwright/test';

test.describe('Route koruması', () => {
  test('token olmadan /admin/dashboard\'a gidilince girişe yönleniyor', async ({ page }) => {
    await page.goto('/admin/dashboard');
    await expect(page).toHaveURL(/\/admin(\?.*)?$/);
  });

  test('token olmadan /admin/orders\'a gidilince girişe yönleniyor', async ({ page }) => {
    await page.goto('/admin/orders');
    await expect(page).toHaveURL(/\/admin(\?.*)?$/);
  });

  test('login sonrası orijinal hedef sayfaya dönülüyor', async ({ page }) => {
    await page.goto('/admin/orders');
    await page.getByLabel('E-posta').fill('admin@shopswift.com');
    await page.getByLabel('Şifre', { exact: true }).fill('admin123');
    await page.getByRole('button', { name: 'Giriş Yap' }).click();
    await expect(page).toHaveURL('/admin/orders');
  });
});