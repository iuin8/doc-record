import { expect, test } from '@playwright/test';

/**
 * 全站问答悬浮入口：面板开关与基本交互。
 *
 * 问答的召回与生成依赖 Pagefind 索引与外部生成端，这里只验证
 * 纯前端的交互行为；端到端问答质量由部署后的生产环境验证。
 */

test('悬浮入口渲染在页面上', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('.ai-ask-launcher')).toBeVisible();
});

test('点击入口展开面板，Esc 关闭', async ({ page }) => {
  await page.goto('/');
  const panel = page.locator('.ai-ask-panel');
  await expect(panel).toBeHidden();

  await page.locator('.ai-ask-open').click();
  await expect(panel).toBeVisible();

  await page.keyboard.press('Escape');
  await expect(panel).toBeHidden();
});
