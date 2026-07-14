import { test, expect } from '@playwright/test';

test.describe('Giriş ekranı', () => {
  test('doğru bilgiyle giriş yapılabiliyor ve dashboard\'a yönleniyor', async ({ page }) => {
    await page.goto('/admin');

    await page.getByLabel('E-posta').fill('admin@shopswift.com');
    await page.getByLabel('Şifre', { exact: true }).fill('admin123');
    await page.getByRole('button', { name: 'Giriş Yap' }).click();

    await expect(page).toHaveURL('/admin/dashboard');
  });

  test('yanlış bilgiyle hata mesajı gösteriliyor', async ({ page }) => {
    await page.goto('/admin');

    await page.getByLabel('E-posta').fill('yanlis@test.com');
    await page.getByLabel('Şifre', { exact: true }).fill('yanlissifre');
    await page.getByRole('button', { name: 'Giriş Yap' }).click();

    await expect(page.getByText('E-posta veya şifre hatalı.')).toBeVisible();
    await expect(page).toHaveURL('/admin');
  });

  test('şifre göster/gizle butonu çalışıyor', async ({ page }) => {
    await page.goto('/admin');

    const passwordInput = page.getByLabel('Şifre', { exact: true });
    await passwordInput.fill('test123');
    await expect(passwordInput).toHaveAttribute('type', 'password');

    await page.getByRole('button', { name: 'Şifreyi göster' }).click();
    await expect(passwordInput).toHaveAttribute('type', 'text');
  });
});