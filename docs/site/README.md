# Neurona documentation

Astro + Starlight sources for <https://kylekahraman.github.io/neurona/>.

## Build and preview

Requirements: Node.js, npm, and the Typst CLI. From this directory:

```sh
npm ci
npm run build
npm run preview
```

The build compiles ten Typst examples in a clean temporary starter folder,
generates matching SVG/source downloads and a starter ZIP, builds Starlight
and its Pagefind search index, then checks internal links, anchors, images,
and downloads. It stops on compilation or link errors. The initial Typst run
needs internet access to retrieve CeTZ.

Content lives in `src/content/docs/`. `Example.astro` reads the generated
manifest so its code is exactly the source used to render the image.
`Gallery.astro` uses the same manifest. `scripts/prepare_examples.py` selects
the examples; introductory sources currently live in `../website/tutorial/`.

Generated `public/files/`, `src/generated/`, `.astro/`, and `dist/` are ignored.
The package's original tutorial notes and release plan remain in `../website/`.

## Hosting with the personal website

The personal website is a separate Astro application. Neurona's built static
site belongs inside that application's `public/neurona/`, with the resulting
`index.html`, `_astro/`, `pagefind/`, and `files/` directories preserved.
Replace that subtree as a unit after each successful documentation build.
Remove the former `src/pages/neurona.astro` route when migrating, since it
would otherwise shadow the new documentation landing page.

The personal website's existing build/deploy workflow copies `public/` to its
GitHub Pages output, preserving the documentation when the rest of the site
is rebuilt. No second workflow should overwrite the root Pages deployment.
