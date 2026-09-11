import type { APIRoute, GetStaticPaths } from 'astro';
import { getCollection } from 'astro:content';

/**
 * 为每篇文档提供与页面同路径的 `.md` 原文。
 *
 * 用途：
 * - 页面上的「复制 Markdown」按钮直接取同源文件，不依赖外部服务；
 * - AI 助手可读取纯文本版本，避免解析页面 HTML。
 */
export const getStaticPaths = (async () => {
  const entries = await getCollection('docs');
  return entries
    .filter((entry) => Boolean(entry.id))
    .map((entry) => ({
      params: { slug: entry.id },
      props: { body: entry.body ?? '' },
    }));
}) satisfies GetStaticPaths;

export const GET: APIRoute = ({ props }) =>
  new Response(props.body, {
    headers: {
      'Content-Type': 'text/markdown; charset=utf-8',
      'Cache-Control': 'public, max-age=3600',
    },
  });
