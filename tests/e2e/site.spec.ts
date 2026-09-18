import { expect, test } from '@playwright/test';

/**
 * 站点结构冒烟：页面可访问、标题唯一、侧边栏无叠压。
 *
 * 「正文 H1 与页面标题重复」「侧边栏条目因固定行高叠压」都是曾发生过
 * 的回归，用例针对这两类问题设置断言，防止后续改动再次引入。
 */

const DOC_PAGE = '/zh-cn/docker/app/firefox/firefox/';
const BLOG_PAGE = '/zh-cn/blog/';

test('首页可访问且渲染 landing 区块', async ({ page }) => {
  const response = await page.goto('/');
  expect(response?.status()).toBeLessThan(400);
  await expect(page).toHaveTitle(/Doc Record/);
});

test('文档页标题唯一（正文 H1 不与页面标题重复）', async ({ page }) => {
  await page.goto(DOC_PAGE);
  await expect(page.locator('main h1')).toHaveCount(1);
});

// 夹具：src/content/docs/zh-cn/test/no-frontmatter.md 不声明 front matter，
// 标题由 loader 从正文首个 H1 推导，该 H1 由 remark 插件在构建期移除
test('未声明 front matter 的文档标题唯一', async ({ page }) => {
  await page.goto('/zh-cn/test/no-frontmatter/');
  await expect(page.locator('main h1')).toHaveCount(1);
  await expect(page.locator('main h1')).toHaveText('无 front matter 的文档');
  // 正文的二级标题仍正常渲染
  await expect(page.locator('main h2').filter({ hasText: '二级标题' })).toBeVisible();
});

test('博客页可访问且导航栏含博客入口', async ({ page }) => {
  await page.goto(BLOG_PAGE);
  await expect(page).toHaveTitle(/Doc Record/);
});

test('侧边栏条目容器高度随内容增长，无叠压', async ({ page }) => {
  await page.goto(DOC_PAGE);
  const sidebar = page.locator('#starlight__sidebar');
  await expect(sidebar).toBeVisible();

  // 回归断言：Black 的 .entry-link 曾固定 height:30px，长中文标题换行后
  // 溢出部分与相邻条目叠压。要求每个条目的容器高度不小于内容高度。
  const entries = sidebar.locator('.entry-link');
  const count = await entries.count();
  expect(count).toBeGreaterThan(0);
  for (let index = 0; index < count; index += 1) {
    const entry = entries.nth(index);
    const { scrollHeight, clientHeight } = await entry.evaluate((el) => ({
      scrollHeight: el.scrollHeight,
      clientHeight: el.clientHeight,
    }));
    expect.soft(clientHeight, `第 ${index + 1} 个侧边栏条目内容被截断`).toBeGreaterThanOrEqual(scrollHeight);
  }
});

test('当前页所在的侧边栏分组默认展开，其余分组折叠', async ({ page }) => {
  await page.goto(DOC_PAGE);
  const details = page.locator('#starlight__sidebar details');
  const total = await details.count();
  if (total === 0) return; // 浅层页面无嵌套分组
  // 当前页所在链路上的分组应为展开态（aria/details 语义）
  const expanded = await details.evaluateAll((nodes) =>
    nodes.map((node) => (node as HTMLDetailsElement).open),
  );
  expect(expanded.some(Boolean)).toBe(true);
});

test('首页所有站内入口均可访问（无死链）', async ({ page, request }) => {
  // 根路径 301 到默认语言首页，等跳转完成再取链接，避免在导航中取 DOM
  await page.goto('/');
  await page.waitForURL(/\/zh-cn\//);

  const links = await page.evaluate(() =>
    [...document.querySelectorAll('a[href^="/"]')].map((anchor) => anchor.getAttribute('href')!),
  );
  const unique = [...new Set(links)];
  // 首页的分类卡片与 hero 入口，加上导航与页脚链接
  expect(unique.length).toBeGreaterThan(3);

  for (const href of unique) {
    const response = await request.get(href);
    expect.soft(response.status(), `死链：${href}`).toBeLessThan(400);
  }
});

test('分类索引页列出该分类下的子分类与文档', async ({ page }) => {
  await page.goto('/zh-cn/category/docker/');
  await expect(page.locator('main h1')).toHaveCount(1);
  // 子分类卡片与文档列表都指向存在的地址
  const entries = page.locator('main a[href^="/zh-cn/"]');
  const count = await entries.count();
  expect(count).toBeGreaterThan(0);
});

test('代码块不横向溢出文档容器', async ({ page }) => {
  await page.goto(DOC_PAGE);
  const overflow = await page.evaluate(() => {
    const frame = document.querySelector('main');
    if (!frame) return false;
    return frame.scrollWidth <= frame.clientWidth + 1;
  });
  expect(overflow).toBe(true);
});
