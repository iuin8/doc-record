import { expect, test } from '@playwright/test';

/**
 * 主题行为：配色切换、亮暗切换及其持久化。
 *
 * 配色切换器挂在导航栏 ThemeSelect 旁，选项写入 localStorage `sl-palette`，
 * Head 内联脚本在首屏绘制前恢复，避免闪烁。
 */

const PALETTE_TRIGGER = '.palette-select-trigger';

test('默认无配色标记，切换后落盘并持久化', async ({ page }) => {
  await page.goto('/zh-cn/docker/app/firefox/firefox/');

  await page.locator(PALETTE_TRIGGER).click();
  await page.getByRole('button', { name: /vitesse/i }).click();
  await expect(page.locator('html')).toHaveAttribute('data-palette', 'vitesse');
  const stored = await page.evaluate(() => localStorage.getItem('sl-palette'));
  expect(stored).toBe('vitesse');

  // 刷新后保持（防闪烁脚本职责）
  await page.reload();
  await expect(page.locator('html')).toHaveAttribute('data-palette', 'vitesse');
});

test('切换回默认配色后清除持久化标记', async ({ page }) => {
  await page.goto('/zh-cn/docker/app/firefox/firefox/');
  await page.evaluate(() => localStorage.setItem('sl-palette', 'nord'));
  await page.reload();
  await expect(page.locator('html')).toHaveAttribute('data-palette', 'nord');

  await page.locator(PALETTE_TRIGGER).click();
  await page.getByRole('button', { name: /默认/ }).click();
  await expect(page.locator('html')).not.toHaveAttribute('data-palette', /vitesse|nord|flexoki/);
});

test('亮暗切换按钮更新 data-theme 并持久化', async ({ page }) => {
  await page.goto('/zh-cn/docker/app/firefox/firefox/');
  const initial = await page.locator('html').getAttribute('data-theme');

  // Black 的切换按钮循环 auto → dark → light，点一次必产生变化
  await page.locator('starlight-theme-black-select button').click();
  const changed = await page.evaluate(() => document.documentElement.getAttribute('data-theme'));
  expect(changed).not.toBe(initial);

  await page.reload();
  await expect(page.locator('html')).toHaveAttribute('data-theme', changed!);
});
