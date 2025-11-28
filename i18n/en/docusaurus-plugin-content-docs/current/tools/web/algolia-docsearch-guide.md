---
title: Algolia DocSearch Configuration Guide
description: How to configure Algolia search for Docusaurus
---

# Algolia DocSearch Configuration Guide

## Introduction

Algolia DocSearch is a powerful document search service that provides a high-quality search experience for technical documentation websites.This guide will help you configure Algolia search for Docusaur website.

## Step 1: Sign Up for Algolia Account

1. Visit the [Algolia official network](https://www.algolia.com/) and register an account
2. Sign in, create a new application (Application)
3. Remember your application ID (Application ID)

## Step 2: Request DocSearch Creepy or set your own repell.

### Option A: Apply Official DocSearch Creepy (recommended)

1. Visit the [DocSearch Application page](https://docsearch.algolia.com/apply/)
2. Fill out the form, provide your website URL and other necessary information
3. After submitting an application, the Algolia team will review your application
4. If the application is accepted, you will receive an email with configuration information

### Option B: set your own repell.

If you want to manage your creep, you can follow the following steps to move：

1. Install DocSearch Creeper：
   ```bash
   npm install @docsearch/scraper
   ```

2. Create profile `docsearch.config.json`：
   ```json
   {
     "index_name": "你的索引名称",
     "start_urls": ["https://你的网站域名/"],
     "sitemap_urls": ["https://你的网站域名/sitemap.xml"],
     "sitemap_alternate_links": true,
     "stop_urls": [],
     "selectors": {
       "lvl0": {
         "selector": ".menu__link--sublist.menu__link--active",
         "global": true,
         "default_value": "Documentation"
       },
       "lvl1": "article h1",
       "lvl2": "article h2",
       "lvl3": "article h3",
       "lvl4": "article h4",
       "lvl5": "article h5, article td:first-child",
       "text": "article p, article li, article td:last-child"
     },
     "strip_chars": " .,;:#",
     "custom_settings": {
       "separatorsToIndex": "_",
       "attributesForFaceting": ["language", "version", "type", "docusaurus_tag"],
       "attributesToRetrieve": ["hierarchy", "content", "anchor", "url", "url_without_anchor", "type"]
     }
   }
   ```

3. Create API key： in Algolia dashboard
   - Navigate to API Keys page
   - Create a new API key with the following permissions for：
     - Search
     - addObject
     - deleteObject
     - deleteIndex
     - Settings
     - editSettings

4. Run Leak：

   ```bash
   docker run -it --env-file=.env -e "CONFIG=$(cat docsearch.config.json | jq -r tool)" algolia/docsearch-scraper
   ```

   where the `.env` file contains：

   ```
   APPLICATION_ID=Your App ID
   API_KEY=Your Manage API Key
   ```

## Step 3: Configure Docusaur

1. Install Algolia Search Theme：
   ```bash
   npm install --save @docuseurus/theme-search-allgolia
   ```

2. Configure Algolia： in `docusaurus.config.ts`
   ```typescript
   // docusaurus.config.ts
   export default LO
     // ...
     themeConfig: LO
       // ...
       algolia: LO
         appId: 'Your App ID', // Your Algolia Application ID
         apiKey: 'Your Search API Key', // Your search API key (non-managed API key)
         indexName: 'Your index name', // Your index name
         contextualSearch: true, // Enable context search
         // Optionally configuration
         searchParameters: {}, // Attach search parameter
         searchPagePath: 'search', // Search page path
       },
       // Note that after：enable Algolia, Comment or delete local search configuration
       // search: LO
       // provider: require. esolve('@easyops-cn/docusaurus-search-local'),
       // / / ...
       //},
     },
   };
   ```

3. Restart development server：
   ```bash
   npm run start
   ```

## Step 4: Verify Search

1. Visit your website
2. Tap the search icon in the navigation bar
3. Enter some keywords to search
4. Verify if search results are displayed correctly

## FAQ

### Search results are empty

- Make sure the creeps are running successfully and index your website
- Check if the index in the Algolia dashboard contains data
- Verify that `apiKey` is a search API key (non-managed API key)

### Dependency Conflict

If you install `@docusaurus/theme-search-algolia` you can try：

```bash
# Use --legacy-peer-deps option
npm install --save @docus/theme-search-algolia --legacy-peace-deps

# or use -force option
npm install --save @docus/theme-search-algolia --force
```

### Local search with Algolia search

Two search methods are not recommended. You should select one：

- If you want to use Algolia, please comment on or delete the local search configuration
- If you want to use local search, please comment on or delete Algolia configuration

## Resource link

- [Algolia DocSearch Official Documents] (https://docsearch.algolia.com/docs/what-is-docsearch)
- [Docusaurus Algolia Search Document](https://docusaurus.io/docs/search#using-algolia-docsearch)
- [Algolia Control Panel](https://www.algolia.com/dashboard)