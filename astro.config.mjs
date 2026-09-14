import { readdirSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightBlog from 'starlight-blog';
import starlightLlmsTxt from 'starlight-llms-txt';

// 全部内容位于默认语言目录下，llms.txt 分卷、重定向映射均以该前缀为基准。
const DEFAULT_LOCALE = 'zh-cn';
const docsDir = fileURLToPath(new URL(`./src/content/docs/${DEFAULT_LOCALE}/`, import.meta.url));
const inDefaultLocale = (path) => `${DEFAULT_LOCALE}/${path}`;

// llms.txt 分卷：完整版约 769 KB，单次取用会占满上下文，
// 按分类拆分后 AI 可只读取相关分卷，完整版作为回退。
const llmsTxtOptions = {
  details:
    '内容以 CommonMark 编写，代码块用围栏语法标注语言。上下文有限时优先取用下列分类分卷。' +
    '全文采用 MIT 许可证，可自由引用与再分发，引用时请注明来源与原文链接。',
  customSets: [
    { label: 'Docker', description: '容器构建、镜像、Compose 与开发环境', paths: [inDefaultLocale('docker/**')] },
    { label: 'Kubernetes', description: '集群部署、运维与问题排查', paths: [inDefaultLocale('kubernetes/**')] },
    {
      label: 'Operating System',
      description: 'Linux、Windows 等系统配置',
      paths: [inDefaultLocale('os/**')],
    },
    {
      label: 'Middleware',
      description: '数据库、消息队列等中间件',
      paths: [inDefaultLocale('middleware/**')],
    },
    {
      label: 'Programming Languages',
      description: '各类编程语言的使用与构建配置',
      paths: [inDefaultLocale('lang/**')],
    },
    { label: 'Network', description: '网络配置、代理与穿透', paths: [inDefaultLocale('network/**')] },
    { label: 'Tools', description: '开发工具与发布脚本', paths: [inDefaultLocale('tools/**')] },
    { label: 'AI', description: 'AI 相关技术、MCP 与应用', paths: [inDefaultLocale('ai/**')] },
    { label: 'Blog', description: '实践记录与问题复盘', paths: [inDefaultLocale('blog/**')] },
    {
      label: 'Notes',
      description: '技术资料、读书笔记与待办',
      paths: [inDefaultLocale('materiel/**'), inDefaultLocale('books/**')],
    },
  ],
};

/**
 * 递归收集默认语言目录下的 Markdown 源文件，换算为内容集合的条目 id。
 * 换算规则与 Astro 的 slug 生成保持一致：去扩展名、小写化、去掉尾部 `index`。
 */
function collectDocIds(dir) {
  return readdirSync(dir, { withFileTypes: true }).flatMap((dirent) => {
    const full = join(dir, dirent.name);
    if (dirent.isDirectory()) return collectDocIds(full);
    if (!/\.mdx?$/.test(dirent.name)) return [];
    const rel = relative(docsDir, full).replace(/\.mdx?$/, '').replace(/\\/g, '/');
    return [`${DEFAULT_LOCALE}/${rel}`.replace(/\/index$/, '').toLowerCase()];
  });
}

/**
 * 语言目录化后全站 URL 由 `/docker/...` 变为 `/zh-cn/docker/...`，
 * 此处为迁移前的每个页面生成一条重定向，避免已收录链接与外部引用失效。
 * 部署目标为 GitHub Pages，无服务端重写能力，Astro 会为每条重定向生成静态跳转页。
 */
function localeRedirects() {
  const redirects = {};
  for (const id of collectDocIds(docsDir)) {
    const suffix = id === DEFAULT_LOCALE ? '' : id.slice(DEFAULT_LOCALE.length + 1);
    redirects[suffix ? `/${suffix}/` : '/'] = `/${id}/`;
  }
  return redirects;
}

// Docusaurus 时期对外分享过的博客短链接，目标按迁移后的语言前缀调整。
// 未列出 slug 的文章，其默认路径与迁移后一致，由上面的批量映射覆盖。
const legacyRedirects = {
  '/blog/cpolar-ssh-container':
    '/zh-cn/blog/docker/dev_utls/dev-container/remote-ssh/cpolar/article/doc',
  '/blog/mihomo-ssh-alias':
    '/zh-cn/blog/docker/dev_utls/dev-container/remote-ssh/clash/mihomo_ssh_config_alias_support',
  '/blog/frp-ssh-clash':
    '/zh-cn/blog/docker/dev_utls/dev-container/remote-ssh/frp/article/frp_ssh组合镜像以及clash打通网络',
  '/blog/frp-ssh-clash-full':
    '/zh-cn/blog/docker/dev_utls/dev-container/remote-ssh/frp/article/frp_ssh组合镜像以及clash打通网络full',
  '/blog/frp-ssh-sshuttle':
    '/zh-cn/blog/docker/dev_utls/dev-container/remote-ssh/frp/article/frp_ssh组合镜像以及sshuttle打通网络',
  '/blog/docker-compose-healthcheck':
    '/zh-cn/blog/docker/doc/article/docker-compose服务间依赖通过自定义健康检查实现顺序启动',
  '/blog/ssh-manual': '/zh-cn/blog/docker/doc/material/manual/article/ssh',
  '/blog/materiel/article/OutOfMemoryError_unable_to_create_new_native_Thread':
    '/zh-cn/blog/materiel/article/outofmemoryerror_unable_to_create_new_native_thread',
  '/blog/materiel/article/SSH远程端口转发配置指南_使用socat实现灵活的端口映射':
    '/zh-cn/blog/materiel/article/ssh远程端口转发配置指南_使用socat实现灵活的端口映射',
  '/blog/materiel/article/一键更换Linux优质的软件源和docker源':
    '/zh-cn/blog/materiel/article/一键更换linux优质的软件源和docker源',
  '/blog/page/2': '/zh-cn/blog/2',
};

export default defineConfig({
  site: 'https://doc-record.iuin888vip.icu',

  // 迁移到语言目录后全站 URL 增加语言前缀，旧链接逐条 301 到新地址；
  // Docusaurus 时期的短链接单独列出，优先于批量映射生效。
  redirects: { ...localeRedirects(), ...legacyRedirects },

  integrations: [
    starlight({
      title: 'Doc Record',
      description: '各类技术文档与解决方案收集',
      favicon: '/img/favicon.ico',
      // 语言目录即 locale 键，有两种取值约束：
      //   1. 键名必须与 src/content/docs/ 下的目录名同为小写。Astro 会把内容集合的
      //      entry.id 整体小写化，Starlight 用 entry.id.startsWith(`${locale}/`) 判定归属，
      //      键名含大写字母时判定失败、页面不会被生成。
      //   2. 只声明实际存在译文目录的语言。Starlight 会为已声明但无译文的语言复制一份
      //      源语言页面作为回退，产生 /en /ja /zh-tw 三份正文完全相同的副本。
      // 译文目录就绪后，在此追加对应条目即可，无需改动内容结构。
      defaultLocale: DEFAULT_LOCALE,
      locales: {
        [DEFAULT_LOCALE]: { label: '中文', lang: 'zh-CN' },
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
