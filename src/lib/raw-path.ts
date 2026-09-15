/**
 * 生成文档对应的 Markdown 原文路径。
 *
 * 内容集合的条目 id 即语言前缀加相对路径，站点索引的 id 为语言键本身（`zh-cn`），
 * 因此可直接拼接。目录迁移前站点索引位于集合根、id 为空串，此处曾需要回退为 `index`；
 * 现结构下该分支不再触发，保留是为兼容 id 缺失的情形。
 */
export function rawMarkdownPath(id: string): string {
  return `/raw/${id || 'index'}.md`;
}

/** 与 `rawMarkdownPath` 对应的静态路由参数。 */
export function rawMarkdownSlug(id: string): string {
  return id || 'index';
}
