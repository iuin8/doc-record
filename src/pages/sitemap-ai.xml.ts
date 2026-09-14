import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

/**
 * 供 AI 检索使用的站点地图，只收录默认语言页面。
 *
 * 站点已按语言目录组织，条目 id 自带语言前缀（`zh-cn/docker/...`），可直接拼成 URL。
 * 未列入 `locales` 的语言不会生成回退副本，因此无需在此过滤重复内容。
 */
export const GET: APIRoute = async ({ site }) => {
  const entries = await getCollection('docs');
  const base = (site ?? new URL('https://doc-record.iuin888vip.icu')).toString().replace(/\/$/, '');

  const urls = entries.map((entry) => {
    const path = entry.id ? `/${entry.id}/` : '/';
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
