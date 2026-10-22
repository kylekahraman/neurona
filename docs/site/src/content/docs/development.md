---
title: Development and release
description: Current package status and the path to the first Typst Universe release.
---

## Current status

Neurona is a development package targeting its first public release. The
current documentation and starter download use the local entry point. A
Typst Universe package import is not available yet.

The implemented drawing vocabulary includes schematic cells, explicit neurite
paths, layers, compartment connections, population boxes, junctions,
experimental timelines, four interneuron recipes, and three circuit motifs.

## Before the first release

1. **Refine the drawing defaults.** Remove the pyramidal tuft protrusion,
   simplify the default branches, and improve route and terminal clearances
   in the two-cell and motif examples.
2. **Prepare the package.** Establish the canonical public repository,
   review metadata and supported Typst versions, and check a clean package
   installation against the documented examples.
3. **Complete release verification.** Review rendered figures at their
   intended sizes, run package checks, and verify documentation links,
   downloads, search, and mobile navigation.
4. **Submit to Typst Universe.** Follow the current
   [Typst package contribution instructions](https://github.com/typst/packages).
   After acceptance, switch public examples to the published versioned import
   and verify them again.

Automatic routing, arbitrary built-in branch counts, reconstructed morphology
adapters, and illustrative electrophysiology are future work. They do not
block releasing the existing drawing toolkit.

## Documentation maintenance

Documentation sources live in `docs/site/` in the Neurona project. Example
preparation compiles the actual downloadable Typst files, then uses those
same source strings in the pages. Build with:

```sh
cd docs/site
npm ci
npm run build
```

The build requires Node.js and the Typst CLI. It generates previews, a starter
ZIP, static pages, and the search index, then checks internal links and
example downloads. Generated assets and build output are not tracked.

## Release history

No Typst Universe release has been published yet. This site documents the
current development version, including work still needed before release.
