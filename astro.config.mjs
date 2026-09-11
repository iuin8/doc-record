import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightBlog from 'starlight-blog';
import starlightLlmsTxt from 'starlight-llms-txt';

// llms.txt 分卷：完整版约 769 KB，单次取用会占满上下文，
// 按分类拆分后 AI 可只读取相关分卷，完整版作为回退。
const llmsTxtOptions = {
  details: '内容以 CommonMark 编写，代码块用围栏语法标注语言。上下文有限时优先取用下列分类分卷。',
  customSets: [
    { label: 'Docker', description: '容器构建、镜像、Compose 与开发环境', paths: ['docker/**'] },
    { label: 'Kubernetes', description: '集群部署、运维与问题排查', paths: ['kubernetes/**'] },
    { label: 'Operating System', description: 'Linux、Windows 等系统配置', paths: ['os/**'] },
    { label: 'Middleware', description: '数据库、消息队列等中间件', paths: ['middleware/**'] },
    {
      label: 'Programming Languages',
      description: '各类编程语言的使用与构建配置',
      paths: ['lang/**'],
    },
    { label: 'Network', description: '网络配置、代理与穿透', paths: ['network/**'] },
    { label: 'Tools', description: '开发工具与发布脚本', paths: ['tools/**'] },
    { label: 'AI', description: 'AI 相关技术、MCP 与应用', paths: ['ai/**'] },
    { label: 'Blog', description: '实践记录与问题复盘', paths: ['blog/**'] },
    { label: 'Notes', description: '技术资料、读书笔记与待办', paths: ['materiel/**', 'books/**'] },
  ],
};

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
      // Starlight 会用条目的 filePath（相对仓库根目录）拼接该前缀，因此这里指向仓库根目录
      editLink: {
        baseUrl: 'https://github.com/iuin8/doc-record/edit/main/',
      },
      // 标题区附带「复制 Markdown / 用 AI 打开」操作，并按需加载 Mermaid
      components: {
        PageTitle: './src/components/PageTitle.astro',
        Head: './src/components/Head.astro',
      },
      plugins: [starlightBlog(), starlightLlmsTxt(llmsTxtOptions)],
    }),
  ],
});
