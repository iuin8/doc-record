/**
 * 生成文档对应的 Markdown 原文路径。
 *
 * 站点根索引（`src/content/docs/index.md`）在 content collection 中的 id 为空字符串，
 * 直接拼接会得到 `/raw/.md`，因此统一回退为 `index`。
 */
export function rawMarkdownPath(id: string): string {
  return `/raw/${id || 'index'}.md`;
}

/** 与 `rawMarkdownPath` 对应的静态路由参数。 */
export function rawMarkdownSlug(id: string): string {
  return id || 'index';
}
