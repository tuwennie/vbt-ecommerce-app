import { test, expect, devices } from '@playwright/test';

test.use({ ...devices['iPhone 13'] });

test.describe('Mobil görünüm', () => {
  test('sidebar varsayılan kapalı, hamburger ile açılıyor', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByRole('link', { name: 'Ev & Ofis' })).not.toBeInViewport();

    await page.getByRole('button', { name: 'Menüyü aç' }).click();
    await expect(page.getByRole('link', { name: 'Ev & Ofis' })).toBeInViewport();
  });

  test('ürün grid\'i mobilde tek sütun', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByText('SonicFlow Wireless Headphones')).toBeVisible({ timeout: 5000 });

    const region = page.getByTestId('featured-products-region');
    const gridEl = region.locator('.grid');
    await expect(gridEl).toHaveClass(/grid-cols-1/);
  });
});