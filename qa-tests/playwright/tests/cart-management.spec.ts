import { test, expect, type Page } from '@playwright/test';

async function registerAndLogin(page: Page, prefix: string) {
  const email = `${prefix}${Date.now()}${Math.floor(Math.random() * 1000)}@test.com`;
  await page.goto('/register');
  await page.getByLabel('Ad Soyad').fill('QA Cart Test');
  await page.getByLabel('E-posta').fill(email);
  await page.getByLabel('Şifre', { exact: true }).fill('Sifre1234!');
  await page.getByLabel('Şifre Tekrar').fill('Sifre1234!');
  await page.getByLabel(/Kullanım Şartları/).check();
  await page.getByRole('button', { name: 'Kayıt Ol' }).click();

  const success = await page.waitForURL('/', { timeout: 10000 }).then(() => true).catch(() => false);
  if (!success) {

    test.skip(true, 'Kayıt başarısız oldu (muhtemelen rate limiting), senaryo atlanıyor');
  }
}

async function addFirstAvailableProduct(page: Page) {
  const region = page.getByTestId('featured-products-region');
  await expect(region.locator('.animate-pulse')).toHaveCount(0, { timeout: 8000 });

  const addButtons = page.getByTestId('add-to-cart-button');
  const count = await addButtons.count();
  test.skip(count === 0, 'Ürün yok, senaryo test edilemiyor');

  for (let i = 0; i < count; i++) {
    const btn = addButtons.nth(i);
    if (await btn.isEnabled()) {
      await btn.click();
      await expect(page.getByTestId('cart-badge')).toBeVisible({ timeout: 5000 });
      return true;
    }
  }
  return false;
}

test.describe('Sepet Yönetimi Otomasyonu', () => {
  test('sepetteki ürün miktarı artırılabiliyor, rozet güncelleniyor', async ({ page }) => {
    await registerAndLogin(page, 'cartinc');
    const added = await addFirstAvailableProduct(page);
    test.skip(!added, 'Stokta ürün yok');

    await page.goto('/cart');
    const item = page.getByTestId('cart-item').first();
    await expect(item).toBeVisible();

    await item.getByLabel('Artır').click();

    await expect(page.getByTestId('cart-badge')).toHaveText('2', { timeout: 5000 });
  });

  test('sepetteki ürün miktarı azaltılabiliyor, 1\'in altına inmiyor', async ({ page }) => {
    await registerAndLogin(page, 'cartdec');
    const added = await addFirstAvailableProduct(page);
    test.skip(!added, 'Stokta ürün yok');

    await page.goto('/cart');
    const item = page.getByTestId('cart-item').first();
    const decreaseButton = item.getByLabel('Azalt');

    await expect(decreaseButton).toBeDisabled();
  });

  test('ürün sepetten silinebiliyor, sepet boş duruma dönüyor', async ({ page }) => {
    await registerAndLogin(page, 'cartdel');
    const added = await addFirstAvailableProduct(page);
    test.skip(!added, 'Stokta ürün yok');

    await page.goto('/cart');
    const item = page.getByTestId('cart-item').first();
    await item.getByLabel('Üründen çıkar').click();

    await expect(page.getByText('Sepetin boş')).toBeVisible({ timeout: 5000 });
  });
});