import React, { useEffect } from 'react';
import SearchBar from '@theme-original/SearchBar';
import AISearchNavbar from '../../components/AISearchNavbar';

type SearchModalElement = HTMLElement & {
  inputElement?: HTMLInputElement | null;
  handleInputChange?: (event: Event) => void;
  debouncedSearch?: {
    cancel?: () => void;
  } | null;
  currentSearchController?: AbortController | null;
  results?: unknown[];
  activeIndex?: number;
  showEmptyState?: () => void;
};

const SEARCH_MODAL_ID = 'cloudflare-ai-search-modal';

function patchSearchModalForSubmitOnly(): () => void {
  const modal = document.getElementById(SEARCH_MODAL_ID) as SearchModalElement | null;

  if (!modal?.inputElement) {
    return () => {};
  }

  const input = modal.inputElement;
  const originalInputHandler = modal.handleInputChange;

  if (input.dataset.aiSearchSubmitOnlyPatched === 'true' || !originalInputHandler) {
    return () => {};
  }

  input.removeEventListener('input', originalInputHandler);

  const submitOnlyInputHandler = (event: Event) => {
    const target = event.target as HTMLInputElement | null;
    const query = target?.value.trim() ?? '';

    if (query.length > 0) {
      modal.debouncedSearch?.cancel?.();
      modal.currentSearchController?.abort?.();
      modal.currentSearchController = null;
      return;
    }

    modal.debouncedSearch?.cancel?.();
    modal.currentSearchController?.abort?.();
    modal.currentSearchController = null;
    modal.results = [];
    modal.activeIndex = -1;
    modal.showEmptyState?.();
  };

  modal.handleInputChange = submitOnlyInputHandler;
  input.addEventListener('input', submitOnlyInputHandler);
  input.dataset.aiSearchSubmitOnlyPatched = 'true';

  return () => {
    input.removeEventListener('input', submitOnlyInputHandler);
    delete input.dataset.aiSearchSubmitOnlyPatched;
    modal.handleInputChange = originalInputHandler;
    input.addEventListener('input', originalInputHandler);
  };
}

export default function SearchBarWithAISearch(): React.JSX.Element {
  useEffect(() => {
    const modal = document.getElementById(SEARCH_MODAL_ID);

    if (modal) {
      return patchSearchModalForSubmitOnly();
    }

    const observer = new MutationObserver(() => {
      const nextModal = document.getElementById(SEARCH_MODAL_ID);

      if (!nextModal) {
        return;
      }

      observer.disconnect();
      patchSearchModalForSubmitOnly();
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true,
    });

    return () => {
      observer.disconnect();
    };
  }, []);

  return (
    <>
      <SearchBar />
      <AISearchNavbar />
    </>
  );
}
