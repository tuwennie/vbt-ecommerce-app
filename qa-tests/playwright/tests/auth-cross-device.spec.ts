import { test, expect, devices } from '@playwright/test';

test.use({ ...devices['iPhone 13'] });

test.describe('Cross-Device - Mobil', () => {
  test('login formu mobilde taşmadan görünüyor, inputlar dokunulabilir boyutta', async ({ page }) => {
    await page.goto('/login');

    const emailInput = page.getByLabel('E-posta');
    await expect(emailInput).toBeVisible();

    const box = await emailInput.boundingBox();
    const viewport = page.viewportSize();

    expect(box && viewport && box.x + box.width).toBeLessThanOrEqual((viewport?.width ?? 0) + 1);
    expect(box?.height).toBeGreaterThanOrEqual(36);
  });

  test('e-posta alanı mobil klavyede "email" tipi tetikliyor (type=email)', async ({ page }) => {
    await page.goto('/login');
    const emailInput = page.getByLabel('E-posta');
    await expect(emailInput).toHaveAttribute('type', 'email');
  });

  test('şifre göster/gizle butonu mobilde de tıklanabiliyor', async ({ page }) => {
    await page.goto('/login');
    const passwordInput = page.getByLabel('Şifre', { exact: true });
    await passwordInput.fill('test123');
    await expect(passwordInput).toHaveAttribute('type', 'password');

    await page.getByRole('button', { name: 'Şifreyi göster' }).click();
    await expect(passwordInput).toHaveAttribute('type', 'text');
  });

  test('register formu mobilde kaydırılarak tüm alanlara ulaşılabiliyor', async ({ page }) => {
    await page.goto('/register');
    await expect(page.getByLabel('Ad Soyad')).toBeVisible();

    const submitButton = page.getByRole('button', { name: 'Kayıt Ol' });
    await submitButton.scrollIntoViewIfNeeded();
    await expect(submitButton).toBeVisible();
  });
});