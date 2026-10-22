import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://kylekahraman.github.io',
  base: '/neurona',
  trailingSlash: 'always',
  markdown: { gfm: true },
  integrations: [starlight({
    title: 'Neurona',
    description: 'Draw neurons, circuits, layers, and experiments in Typst.',
    favicon: '/favicon.svg',
    editLink: { baseUrl: 'https://github.com/kylekahraman/neurona/edit/main/docs/site/' },
    customCss: ['./src/styles/custom.css'],
    social: [
      { icon: 'github', label: 'Source on GitHub', href: 'https://github.com/kylekahraman/neurona' },
      { icon: 'external', label: 'Kyle Kahraman', href: 'https://kylekahraman.github.io/projects/' },
    ],
    sidebar: [
      { label: 'Overview', slug: 'index' },
      { label: 'Get started', items: [
        { slug: 'getting-started/installation' },
        { slug: 'getting-started/first-figure' },
      ] },
      { label: 'Guides', items: [
        { slug: 'guides/models' }, { slug: 'guides/cells' }, { slug: 'guides/connections' },
        { slug: 'guides/layers' }, { slug: 'guides/timelines' },
        { slug: 'guides/recipes' }, { slug: 'guides/styling-and-export' },
      ] },
      { label: 'Gallery', slug: 'gallery' },
      { label: 'API reference', items: [
        { slug: 'reference/models' }, { slug: 'reference/cells' }, { slug: 'reference/circuits' },
        { slug: 'reference/layers' }, { slug: 'reference/experiments' },
      ] },
      { label: 'Development', slug: 'development' },
    ],
  })],
});
