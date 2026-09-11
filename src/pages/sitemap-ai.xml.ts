import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

/**
 * 供 AI 检索使用的站点地图，只收录根语言页面。
 *
 * 通用站点地图包含 en / ja / zh-Hant 的回退副本（内容尚未翻译，与根语言页面一致），
 * 直接用于索引会产生三倍重复内容，浪费算力并干扰检索结果。
 */
export const GET: APIRoute = async ({ site }) => {
  const entries = await getCollection('docs');
  const base = (site ?? new URL('https://doc-record.iuin888vip.icu')).toString().replace(/\/$/, '');

  const urls = entries.map((entry) => {
    const path = entry.id && entry.id !== 'index' ? `/${entry.id}/` : '/';
    return `  <url><loc>${base}${path}</loc></url>`;
  });

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.join('\n')}
</urlset>
`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml; charset=utf-8',
      'Cache-Control': 'public, max-age=3600',
    },
  });
};
