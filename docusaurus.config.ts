import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const defaultLocale = 'zh-Hans';

const config: Config = {
  title: 'Doc Record',
  tagline: '个人文档记录',
  favicon: 'img/favicon.ico',

  url: 'https://iuin8.github.io',
  baseUrl: '/doc-record',

  organizationName: 'iuin8', 
  projectName: 'doc-record',

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  // markdown 配置
  // 备注：下方每项均标注【默认值】与【更优解建议】
  markdown: {
    format: 'detect', // 根据文件扩展名自动选择格式  'mdx' | 'md' | 'detect'

    // 是否启用 mermaid 流程图/时序图等支持
    // 默认值：false
    // 更优解：
    //  - 若需要绘图，设为 true，并在下方顶层添加 themes: ['@docusaurus/theme-mermaid']
    //  - 若不使用绘图，保持 false 可降低体积
    mermaid: true,

    // 标题锚点生成策略
    // 默认值：maintainCase: false（会统一转小写）
    // 更优解：
    //  - 为了与 GitHub/多数平台的锚点规则保持一致，通常建议使用默认 false
    //  - 若确需区分大小写（例如外部链接已约定大小写），可设为 true
    // anchors: {
    //   maintainCase: true,
    // },
  },

  i18n: {
    defaultLocale: defaultLocale,
    locales: [defaultLocale, 'en'],
    localeConfigs: {
      'zh-Hans': {
        label: '中文',
        direction: 'ltr',
      },
      'en': {
        label: 'English',
        direction: 'ltr',
      },
    },
  },

  plugins: [
    [
      "@easyops-cn/docusaurus-search-local",
      {
        hashed: true,
        language: ['zh', 'en'], // 支持中英文搜索
        highlightSearchTermsOnTargetPage: true,
        explicitSearchResultPath: false,
        searchResultLimits: 10,
        searchResultContextMaxLength: 100,
        docsRouteBasePath: '/',
        indexBlog: false, // 因为禁用了博客
      }
    ],
  ],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/', // 将文档设置为首页
          editUrl: ({locale, versionDocsDirPath, docPath}) => {
            // if (locale !== defaultLocale) {
            //   return `https://github.com/iuin8/doc-record/${locale}`;
            // }
            return `https://github.com/iuin8/doc-record/blob/main/${versionDocsDirPath}/${docPath}`;
          },
          remarkPlugins: [
            // 支持GitHub Flavored Markdown
            require('remark-gfm'),
            // 支持数学公式
            require('remark-math'),
            // 支持Admonitions（提示框）
            require('remark-directive'),
          ],
          rehypePlugins: [
            // 数学公式渲染
            require('rehype-katex'),
            // 代码块语法高亮增强
            require('rehype-prism-plus'),
          ],
        },
        blog: false, // 禁用博客功能
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'Doc Record',
      logo: {
        alt: 'Doc Record Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docSidebar',
          position: 'left',
          label: '文档',
        },
        {
          type: 'localeDropdown',
          position: 'right',
        },
        {
          href: 'https://github.com/iuin8/doc-record',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    announcementBar: {
      content:
        '⭐️ 如果喜欢这个项目，请在<a target="_blank" rel="noopener noreferrer" href="https://github.com/iuin8/doc-record">GitHub</a>上给个星！⭐️',
      backgroundColor: '#fafbfc',
      textColor: '#091e42',
      isCloseable: true,
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: '文档',
          items: [
            {
              label: '首页',
              to: '/',
            },
          ],
        },
        {
          title: '更多',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/183461750/doc-record',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Doc Record. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['bash', 'javascript', 'typescript', 'python', 'java'],
    },
    // 数学公式配置
    math: {
      mathjax: {
        version: 3,
        tex: {
          tags: 'ams',
          environments: {
            equation: ['equation*', 'ams'],
          },
        },
      },
    },
  } satisfies Preset.ThemeConfig,

  // 为 mermaid 启用主题支持
  // 默认值：无（未启用）
  // 更优解：仅当 markdown.mermaid 为 true 且确实使用图表时启用，以避免不必要依赖
  themes: ['@docusaurus/theme-mermaid'],
};

export default config;
