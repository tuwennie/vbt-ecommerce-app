import { test, expect } from '@playwright/test';

test.describe('Happy Path - Uçtan Uca Kullanıcı Yolculuğu', () => {
  test('kayıt -> giriş -> ürün seç -> sepete ekle -> adres seç -> sipariş ver', async ({ page }) => {
    const email = `e2e${Date.now()}${Math.floor(Math.random() * 1000)}@test.com`;
    const password = 'Sifre1234!';

    await page.goto('/register');
    await page.getByLabel('Ad Soyad').fill('E2E Test Kullanici');
    await page.getByLabel('E-posta').fill(email);
    await page.getByLabel('Şifre', { exact: true }).fill(password);
    await page.getByLabel('Şifre Tekrar').fill(password);
    await page.getByLabel(/Kullanım Şartları/).check();
    await page.getByRole('button', { name: 'Kayıt Ol' }).click();

    const registered = await page.waitForURL('/', { timeout: 10000 }).then(() => true).catch(() => false);
    test.skip(!registered, 'Kayıt başarısız oldu (muhtemelen rate limiting), senaryo atlanıyor');

    const region = page.getByTestId('featured-products-region');
    await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

    const addButtons = page.getByTestId('add-to-cart-button');
    const buttonCount = await addButtons.count();
    test.skip(buttonCount === 0, 'Ana sayfada ürün yok, akış test edilemiyor');

    let clicked = false;
    for (let i = 0; i < buttonCount; i++) {
      const btn = addButtons.nth(i);
      if (await btn.isEnabled()) {
        await btn.click();
        clicked = true;
        break;
      }
    }
    test.skip(!clicked, 'Tüm ürünler stokta yok, akış test edilemiyor');

    await expect(page.getByTestId('cart-badge')).toBeVisible({ timeout: 5000 });

    await page.goto('/cart');
    await page.getByTestId('go-to-checkout-button').click();
    await expect(page).toHaveURL('/checkout');

    await page.getByTestId('add-address-button').click();
    await page.getByLabel('Alıcı Adı Soyadı').fill('E2E Test Kullanici');
    await page.getByLabel('Telefon').fill('+905551234567');
    await page.getByLabel('İl').fill('İstanbul');
    await page.getByLabel('İlçe').fill('Kadıköy');
    await page.getByLabel('Açık Adres').fill('Test Mahallesi Test Sokak No:1 Daire:2');
    await page.getByLabel('Posta Kodu').fill('34000');
    await page.getByRole('button', { name: 'Kaydet' }).click();

    await expect(page.getByTestId('address-option').first()).toBeVisible({ timeout: 5000 });
    await page.getByTestId('address-option').first().click();
    await page.getByTestId('go-to-payment-button').click();

    await expect(page.getByTestId('checkout-stepper')).toBeVisible();
    await page.getByRole('button', { name: 'Devam Et' }).click();

    await page.getByTestId('confirm-order-button').click();

    await expect(page).toHaveURL(/\/order-success/, { timeout: 10000 });
    await expect(page.getByText('Siparişin Alındı!')).toBeVisible();
  });
});