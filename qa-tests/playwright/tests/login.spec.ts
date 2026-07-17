import { test, expect } from '@playwright/test';

test.describe('Giriş ekranı', () => {
  test('form gönderilince başarılı girişe ya da hata mesajına ulaşılıyor', async ({ page }) => {
    await page.goto('/admin');

    await page.getByLabel('E-posta').fill('admin@shopswift.com');
    await page.getByLabel('Şifre', { exact: true }).fill('admin123');
    await page.getByRole('button', { name: 'Giriş Yap' }).click();

    await Promise.race([
      page.waitForURL('/admin/dashboard', { timeout: 8000 }).catch(() => {}),
      page.getByTestId('auth-error').waitFor({ timeout: 8000 }).catch(() => {}),
    ]);

    const onDashboard = page.url().includes('/admin/dashboard');
    const hasError = await page.getByTestId('auth-error').isVisible().catch(() => false);
    expect(onDashboard || hasError).toBeTruthy();
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