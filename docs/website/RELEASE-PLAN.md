# Neurona: first public release

## Objective

Publish a small, visually reliable Neurona package on Typst Universe with a
proper documentation site at `https://kylekahraman.github.io/neurona/`.
The larger feature roadmap stays in `ROADMAP.md`; new cell types, signals,
morphology adapters, and automatic routing do not block the first release.

## Documentation recommendation

Use Astro with the standard Starlight documentation theme, with restrained
Neurona colors and generous white figure panels. GDA already uses Starlight;
Satz uses Zensical. Both support conventional documentation. Starlight is
recommended here for reusable visual-example components in MDX, alongside
search, grouped navigation, code blocks, and a page table of contents.

Keep documentation sources in the Neurona repository. Build a static site
with base `/neurona/`; coordinate deployment with the personal website so
that either workflow preserves the other site's output.

Proposed navigation:

- Start: installation and first figure.
- Guides: cells, connections and ports, layers, timelines, styling and export.
- Gallery: thumbnails leading to complete, editable examples.
- Reference: constructors, parameters, defaults, compatible ports, and units.
- Development: release status, contributing, and changelog.

Use one reusable example component: compiled SVG, exact compiling source,
copy button, and source/SVG downloads. Generate previews from the same source
shown on the page so the two cannot drift apart. Preserve source whitespace.

## 1. Fix the visual baseline

- Remove the apical trunk protrusion at the tuft bifurcation. The current
  trunk reaches `0.76 * apical`, while the tuft starts at `0.69 * apical`.
- Simplify the default pyramidal illustration: one apical trunk, a clear
  terminal bifurcation, fewer oblique branches, and a compact basal arbor.
  Keep richer detail explicitly selectable. Decide which named ports must
  remain stable before altering geometry.
- Reroute the two-cell tutorial connections away from the basal arbors;
  preserve the intended target compartments and clear terminal symbols.
- Fix the feedforward motif's crowded inhibitory terminal near the apical
  arbor; review feedback and disinhibition with the same criteria.
- Review labels, ports, and connections at intended paper and slide sizes,
  including rotated/scaled cells and both detail settings. Add focused
  geometry regression checks for the defects, plus rendered visual review.

Done when all public examples compile and the reported defects are absent
from the rendered gallery. Compilation alone is insufficient.

## 2. Prepare a releasable package

- Establish the public Neurona repository and canonical URL; the current
  manifest still names the former `paradigm` repository.
- Review the exported API, defaults, supported Typst version, license, and
  package metadata. Check current Typst package submission requirements.
- Stage a clean package containing every required source file and no
  website build files, duplicate working directories, or incidental assets.
- Verify imports from the staged package rather than the development tree.
  Compile tutorial examples and run the existing focused package checks.
- Record the release scope and changes, and tag the approved release.

Done when a clean installation reproduces every documented example.

## 3. Build the documentation site

- Replace the long tutorial page with the Starlight navigation above.
- Retain the visual examples and improve their layouts after geometry fixes.
- Put API details beside relevant examples instead of accumulating warnings.
- Remove the prominent generic biology note from the tutorial. Keep concise
  source/context notes only where a particular anatomical recipe needs them.
- Until publication, explain local imports once in development setup. After
  publication, make versioned package imports the default throughout public
  examples; retain local-import troubleshooting only in development docs.
- Verify search, internal links, mobile layout, copy buttons, and downloads.

## 4. Submit and publish

- Submit the release to `typst/packages` following its current contribution
  requirements. Submission and acceptance are distinct milestones.
- Once the version is available, verify a fresh registry import such as
  `#import "@preview/neurona:0.1.0": circuit, neuron` (version subject to the
  release decision). Do not advertise it as available before acceptance.
- Update and recompile all public examples using that import, deploy the
  documentation, and check the live pages and downloadable sources.

## Sources

- Starlight components: https://starlight.astro.build/components/using-components/
- Starlight search: https://starlight.astro.build/guides/site-search/
- Typst package repository and contribution instructions: https://github.com/typst/packages
