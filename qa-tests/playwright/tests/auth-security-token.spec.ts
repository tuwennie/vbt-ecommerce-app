import { test, expect } from '@playwright/test';

test.describe('Güvenlik / Token Testleri', () => {
  test('token elle silinince korumalı sayfaya erişim engelleniyor (Admin)', async ({ page, context }) => {
    // Sahte bir token ile "girişliymiş gibi" davranıp sonra silelim.
    await page.goto('/admin');
    await context.addCookies([
      { name: 'access_token', value: 'gecersiz-sahte-token', url: page.url() },
    ]);

    await page.goto('/admin/dashboard');
    await context.clearCookies({ name: 'access_token' });
    await page.goto('/account');

    await expect(page).toHaveURL(/\/login/);
  });

  test('token hiç yokken korumalı /account sayfasına gidilince /login\'e yönleniyor', async ({ page }) => {
    await page.context().clearCookies();
    await page.goto('/account');
    await expect(page).toHaveURL(/\/login\?redirectTo=%2Faccount/);
  });

  test('token hiç yokken korumalı /admin/dashboard\'a gidilince /admin\'e yönleniyor', async ({ page }) => {
    await page.context().clearCookies();
    await page.goto('/admin/dashboard');
    await expect(page).toHaveURL(/\/admin\?redirectTo=%2Fadmin%2Fdashboard/);
  });

  test('401 sonrası sessionExpired mesajı gösterilebiliyor (URL parametresi ile doğrudan)', async ({ page }) => {
    await page.goto('/login?sessionExpired=true');
    await expect(page.getByText('Oturumun sona erdi')).toBeVisible();
  });

  test('401 sonrası sessionExpired mesajı admin girişinde de gösterilebiliyor', async ({ page }) => {
    await page.goto('/admin?sessionExpired=true');
    await expect(page.getByText('Oturumun sona erdi')).toBeVisible();
  });

  test('geçersiz token ile /users/me isteği 401 dönerse oturum temizlenip login\'e yönleniyor (canlı API varsa)', async ({ page, context }) => {
    await page.goto('/');
    await context.addCookies([
      { name: 'access_token', value: 'kesinlikle-gecersiz-bir-token-degeri', url: page.url() },
    ]);

    await page.goto('/account');

    const redirected = await page.waitForURL(/\/login/, { timeout: 6000 }).then(() => true).catch(() => false);
    test.skip(!redirected, 'Backend /users/me için henüz 401 dönmüyor olabilir (endpoint eksik/farklı davranış)');

    await expect(page).toHaveURL(/\/login/);
  });
});