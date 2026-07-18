import { test, expect } from '@playwright/test';

test.describe('Negatif Senaryolar - B2C', () => {
  test('yanlış şifre ile giriş → hata mesajı gösteriliyor, uygulama çökmüyor', async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel('E-posta').fill('mevcut.olmayan@test.com');
    await page.getByLabel('Şifre', { exact: true }).fill('YanlisSifre123!');
    await page.getByRole('button', { name: 'Giriş Yap' }).click();

    await expect(page.getByTestId('auth-error')).toBeVisible({ timeout: 8000 });
    
    await expect(page).toHaveURL(/\/login/);
  });

  test('geçersiz e-posta formatı ile form gönderilemiyor (tarayıcı validasyonu devrede)', async ({ page }) => {
    await page.goto('/login');
    const emailInput = page.getByLabel('E-posta');
    await emailInput.fill('gecersiz-email');
    await page.getByLabel('Şifre', { exact: true }).fill('herhangibir');
    await page.getByRole('button', { name: 'Giriş Yap' }).click();
    await expect(page).toHaveURL(/\/login/);
    const isValid = await emailInput.evaluate((el: HTMLInputElement) => el.validity.valid);
    expect(isValid).toBeFalsy();
  });

  test('kayıt formunda şifre eşleşmiyorsa hata gösteriliyor', async ({ page }) => {
    await page.goto('/register');
    await page.getByLabel('Ad Soyad').fill('Test Kullanici');
    await page.getByLabel('E-posta').fill(`test${Date.now()}@test.com`);
    await page.getByLabel('Şifre', { exact: true }).fill('Sifre1234!');
    await page.getByLabel('Şifre Tekrar').fill('FarkliSifre123!');
    await page.getByLabel(/Kullanım Şartları/).check();
    await page.getByRole('button', { name: 'Kayıt Ol' }).click();

    await expect(page.getByTestId('auth-error')).toBeVisible();
    await expect(page.getByTestId('auth-error')).toContainText('eşleşmiyor');
  });

  test('kayıt formunda kısa şifre reddediliyor', async ({ page }) => {
    await page.goto('/register');
    await page.getByLabel('Ad Soyad').fill('Test Kullanici');
    await page.getByLabel('E-posta').fill(`test${Date.now()}@test.com`);
    await page.getByLabel('Şifre', { exact: true }).fill('123');
    await page.getByLabel('Şifre Tekrar').fill('123');
    await page.getByLabel(/Kullanım Şartları/).check();
    await page.getByRole('button', { name: 'Kayıt Ol' }).click();

    await expect(page.getByTestId('auth-error')).toBeVisible();
    await expect(page.getByTestId('auth-error')).toContainText('8 karakter');
  });

  test('kullanım şartları kabul edilmeden kayıt olunamıyor', async ({ page }) => {
    await page.goto('/register');
    await page.getByLabel('Ad Soyad').fill('Test Kullanici');
    await page.getByLabel('E-posta').fill(`test${Date.now()}@test.com`);
    await page.getByLabel('Şifre', { exact: true }).fill('Sifre1234!');
    await page.getByLabel('Şifre Tekrar').fill('Sifre1234!');
    await page.getByRole('button', { name: 'Kayıt Ol' }).click();

    await expect(page.getByTestId('auth-error')).toBeVisible();
    await expect(page.getByTestId('auth-error')).toContainText('şartları');
  });

  test('mükerrer kayıt denemesi hata veriyor (aynı e-posta ile iki kez kayıt)', async ({ page }) => {
    const email = `mukerrer${Date.now()}@test.com`;

    await page.goto('/register');
    await page.getByLabel('Ad Soyad').fill('İlk Kayit');
    await page.getByLabel('E-posta').fill(email);
    await page.getByLabel('Şifre', { exact: true }).fill('Sifre1234!');
    await page.getByLabel('Şifre Tekrar').fill('Sifre1234!');
    await page.getByLabel(/Kullanım Şartları/).check();
    await page.getByRole('button', { name: 'Kayıt Ol' }).click();

    await page.waitForTimeout(2000);
    await page.goto('/register');
    await page.getByLabel('Ad Soyad').fill('Ikinci Kayit');
    await page.getByLabel('E-posta').fill(email);
    await page.getByLabel('Şifre', { exact: true }).fill('Sifre1234!');
    await page.getByLabel('Şifre Tekrar').fill('Sifre1234!');
    await page.getByLabel(/Kullanım Şartları/).check();
    await page.getByRole('button', { name: 'Kayıt Ol' }).click();

    await expect(page.getByTestId('auth-error')).toBeVisible({ timeout: 8000 });
  });
});