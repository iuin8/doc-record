import React from 'react';
import { translate } from '@docusaurus/Translate';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

const SEARCH_API_URL =
  'https://b9b71958-6156-440e-a28f-b4105ff6a50c.search.ai.cloudflare.com/';
const SEARCH_MODAL_ID = 'cloudflare-ai-search-modal';

type SearchModalElement = HTMLElement & {
  open?: () => void;
};

function openSearchModal(): void {
  const modal = document.getElementById(SEARCH_MODAL_ID) as SearchModalElement | null;
  modal?.open?.();
}

const SEARCH_LABELS = {
  'zh-Hans': {
    button: 'AI 搜索',
    placeholder: '搜索文档...',
    ariaLabel: '打开 AI 搜索',
  },
  en: {
    button: 'AI Search',
    placeholder: 'Search docs...',
    ariaLabel: 'Open AI search',
  },
  'zh-Hant': {
    button: 'AI 搜尋',
    placeholder: '搜尋文件...',
    ariaLabel: '打開 AI 搜尋',
  },
  ja: {
    button: 'AI検索',
    placeholder: 'ドキュメントを検索...',
    ariaLabel: 'AI検索を開く',
  },
} as const;

export default function AISearchNavbar(): React.JSX.Element {
  const {
    i18n: { currentLocale },
  } = useDocusaurusContext();
  const theme = 'light';
  const labels = SEARCH_LABELS[currentLocale as keyof typeof SEARCH_LABELS] ??
    SEARCH_LABELS['zh-Hans'];
  const shortcutLabel = translate({
    id: 'theme.DocRecord.AISearchNavbar.shortcut',
    message: '⌘K',
  });

  return (
    <>
      <button
        type="button"
        className="navbar__item cloudflare-ai-search-button"
        onClick={openSearchModal}
        aria-label={labels.ariaLabel}>
        <span className="cloudflare-ai-search-button__icon" aria-hidden="true">
          ⌕
        </span>
        <span className="cloudflare-ai-search-button__label">{labels.button}</span>
        <kbd className="cloudflare-ai-search-button__shortcut">{shortcutLabel}</kbd>
      </button>
      {React.createElement('search-modal-snippet', {
        id: SEARCH_MODAL_ID,
        'api-url': SEARCH_API_URL,
        placeholder: labels.placeholder,
        shortcut: 'k',
        'show-url': 'true',
        'show-date': 'true',
        theme,
      })}
    </>
  );
}
