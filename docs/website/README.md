# Website tutorial

`neurona.astro` is the tutorial page for `kylekahraman.github.io/neurona/`.
It uses the website's existing `SiteLayout` and Astro's syntax highlighting.
The six `tutorial/*.typ` files are complete, compilable examples.

To update the website, copy the page to its `src/pages/neurona.astro` and the
examples to `public/neurona/files/`. Compile matching SVG previews from the
starter folder, with the examples in `examples/` and `lib.typ` at the root:

```sh
typst compile --root . examples/01-cell.typ 01-cell.svg
```

Repeat for all six examples. Place the SVGs beside the downloadable `.typ`
files. Bundle the current `lib.typ`, `src/`, `LICENSE`, `README.md`, `docs/`
(excluding this website source directory), and example `.typ` files into
`neurona-starter.zip` with a top-level `neurona-starter/` folder. The bundle
uses local imports and includes CeTZ as a dependency fetched by Typst.
The website's existing push workflow builds Astro and deploys to GitHub Pages.
