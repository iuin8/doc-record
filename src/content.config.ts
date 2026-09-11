import { readFile } from 'node:fs/promises';

import { defineCollection } from 'astro:content';
import type { Loader } from 'astro/loaders';
import { z } from 'astro/zod';
import { docsLoader } from '@astrojs/starlight/loaders';
import { docsSchema } from '@astrojs/starlight/schema';
import { blogSchema } from 'starlight-blog/schema';

/** 首个一级标题，用于在未声明 title 时推导页面标题。 */
const FIRST_H1 = /^#[ \t]+(.+?)[ \t]*$/m;

/** 去除行内 Markdown 标记，避免标题中残留 `**` 之类的符号。 */
function stripInlineMarkdown(value: string): string {
  return value
    .replace(/`([^`]*)`/g, '$1')
    .replace(/\*\*([^*]*)\*\*/g, '$1')
    .replace(/\*([^*]*)\*/g, '$1')
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .trim();
}

const base = docsLoader();

/**
 * 包装 Starlight 的 docsLoader，为未声明 title 的文档按首个一级标题推导标题。
 *
 * 目的：Markdown 保持原生态，作者无需为了通过构建而写 front matter。
 * title 仍是可选的标准字段，显式声明时优先使用。
 */
const docsLoaderWithTitleFallback: Loader = {
  name: 'starlight-docs-title-fallback',
  async load(context) {
    await base.load(context);

    for (const entry of context.store.values()) {
      if (entry.data?.title) continue;

      let title = '';
      if (entry.filePath) {
        try {
          const raw = await readFile(new URL(entry.filePath, context.config.root), 'utf8');
          const match = FIRST_H1.exec(raw);
          if (match) title = stripInlineMarkdown(match[1]);
        } catch {
          title = '';
        }
      }

      // 无一级标题时回退为文件名，与主流静态站点生成器的行为一致
      if (!title) title = entry.id.split('/').pop() ?? entry.id;

      entry.data = { ...entry.data, title };
    }
  },
};

export const collections = {
  docs: defineCollection({
    loader: docsLoaderWithTitleFallback,
    schema: docsSchema({
      // title 降为可选：未声明时由 loader 从正文推导
      extend: (context) =>
        blogSchema(context).extend({ title: z.string().optional() }),
    }),
  }),
};
