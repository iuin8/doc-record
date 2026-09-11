import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightBlog from 'starlight-blog';

export default defineConfig({
  site: 'https://doc-record.iuin888vip.icu',
  integrations: [
    starlight({
      title: 'Doc Record',
      description: '各类技术文档与解决方案收集',
      favicon: '/img/favicon.ico',
      defaultLocale: 'root',
      locales: {
        root: { label: '中文', lang: 'zh-CN' },
        en: { label: 'English', lang: 'en' },
        'zh-Hant': { label: '繁體中文', lang: 'zh-TW' },
        ja: { label: '日本語', lang: 'ja' },
      },
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/iuin8/doc-record' },
      ],
      editLink: {
        baseUrl: 'https://github.com/iuin8/doc-record/edit/main/src/content/docs/',
      },
      plugins: [starlightBlog()],
    }),
  ],
});
