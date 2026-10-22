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

The source is public at [kylekahraman/neurona](https://github.com/kylekahraman/neurona).

## Release candidate checks

The 0.1.0 candidate now uses compact default cell drawings, with the apical
trunk ending at the tuft bifurcation. Introductory connections route around
the arbors, and motif terminals target an exposed oblique branch endpoint.
Rendered SVG regression checks cover the tuft geometry.

The library and isolated package imports have been tested on **Typst 0.13.1
and 0.15.0**. The candidate bundle includes only the runtime source, manifest,
license, and README. The full CI pipeline also checks the documentation and
runs Typst's official package checker.

## Before submission

The remaining acceptance step is Kyle's hands-on trial: make a real figure
using the documentation, then resolve any usability findings. Automated
checks establish compilation and geometric properties; they do not establish
that the API is intuitive.

To try package-style imports locally from a repository checkout:

```sh
python3 scripts/release.py --check
typst watch --package-path build/submission build/try-neurona.typ build/try-neurona.pdf
```

Edit `build/try-neurona.typ` to create your own diagram. The generated package
path resolves the candidate without installing it globally.

After the acceptance check and passing CI, the candidate can be submitted
under the [Typst package contribution instructions](https://github.com/typst/packages).
After acceptance, public examples will switch to the registry import.

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
