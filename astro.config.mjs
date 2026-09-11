import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightBlog from 'starlight-blog';

export default defineConfig({
  site: 'https://doc-record.iuin888vip.icu',

  // 迁移前的 Docusaurus 博客 URL 保持不变，避免外部链接失效。
  // 未列出 slug 的文章，其默认路径与迁移后一致，无需重定向。
  redirects: {
    '/blog/cpolar-ssh-container':
      '/blog/docker/dev_utls/dev-container/remote-ssh/cpolar/article/doc',
    '/blog/mihomo-ssh-alias':
      '/blog/docker/dev_utls/dev-container/remote-ssh/clash/mihomo_ssh_config_alias_support',
    '/blog/frp-ssh-clash':
      '/blog/docker/dev_utls/dev-container/remote-ssh/frp/article/frp_ssh组合镜像以及clash打通网络',
    '/blog/frp-ssh-clash-full':
      '/blog/docker/dev_utls/dev-container/remote-ssh/frp/article/frp_ssh组合镜像以及clash打通网络full',
    '/blog/frp-ssh-sshuttle':
      '/blog/docker/dev_utls/dev-container/remote-ssh/frp/article/frp_ssh组合镜像以及sshuttle打通网络',
    '/blog/docker-compose-healthcheck':
      '/blog/docker/doc/article/docker-compose服务间依赖通过自定义健康检查实现顺序启动',
    '/blog/ssh-manual': '/blog/docker/doc/material/manual/article/ssh',
    '/blog/materiel/article/OutOfMemoryError_unable_to_create_new_native_Thread':
      '/blog/materiel/article/outofmemoryerror_unable_to_create_new_native_thread',
    '/blog/materiel/article/SSH远程端口转发配置指南_使用socat实现灵活的端口映射':
      '/blog/materiel/article/ssh远程端口转发配置指南_使用socat实现灵活的端口映射',
    '/blog/materiel/article/一键更换Linux优质的软件源和docker源':
      '/blog/materiel/article/一键更换linux优质的软件源和docker源',
    '/blog/page/2': '/blog/2',
  },

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
