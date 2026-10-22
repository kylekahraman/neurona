# Neurona 0.1.0 release candidate

## Completed

- Simplified the default cell detail to `minimal`; `branched` remains explicit.
- Removed the apical trunk protrusion at the tuft bifurcation.
- Rerouted the introductory two-cell example around the arbors and moved
  motif inhibitory terminals to an exposed oblique branch endpoint.
- Added a regression check against the actual rendered SVG paths for the
  default, minimal, and branched pyramidal drawings.
- Compiled the examples and semantic tests, including rejection cases, on
  Typst 0.13.1 and 0.15.0. The manifest records 0.13.1 as the minimum.
- Prepared a minimal submission tree with the manifest, license, README,
  entry point, and eight source modules. Documentation links in the staged
  README point to a fixed source revision; website dependencies and gallery
  assets are not included in the runtime bundle.
- Compiled 33 standalone client documents from outside the source tree with
  the staged `@preview/neurona:0.1.0` import, plus SVG and PNG exports.
  These cover the repository examples, all six introductory examples, and
  each Typst code block in the submission README.
- Added abstract diagrams with equation blocks, state nodes, custom ports, groups,
  and neutral links. The user-reference model has an exact graph regression;
  actual rendered node anchors, mixed scenes, and invalid inputs are tested.
- CI uses the latest stable Typst release, the official Universe package checker,
  and the documentation build/link checks.

## Your usability check

The remaining user acceptance check is to draw something you actually need,
using the public documentation. The automated checks above establish
compilation and drawing properties; they do not establish intuitive use.

For a local package-style trial, from the repository root:

```sh
python3 scripts/release.py --check
```

Edit `build/try-neurona.typ` and compile it with:

```sh
typst watch --package-path build/submission build/try-neurona.typ build/try-neurona.pdf
```

This resolves the candidate from the generated package directory. It does
not install anything globally or require the package to be published.
The existing documentation starter ZIP is another way to try the same
library using local imports in the Typst web app.

Choose your own figure. Useful operations to try include changing cell
shapes/geometry, targeting a compartment, placing cells in layers, changing
a label, and exporting at the intended paper/slide size. Record unclear
names, surprising defaults, routing effort, and places where you need help.

## Submission handoff

Run `python3 scripts/release.py --check` after the final committed changes.
The output includes:

- `build/submission/preview/neurona/0.1.0/`: files for the Universe submission.
- `build/neurona-0.1.0-candidate.zip`: the same submission tree as an archive.
- `build/release-check.json`: file list, compiler version, source revision,
  runtime size, and successful client checks.

Require the GitHub Actions package/documentation checks to pass and resolve
usability findings before submitting. No release tag or Universe submission
has been created. Once accepted, switch public installation/examples to the
registry import and verify them against the published version.

Automatic routing, extra cell families, arbitrary built-in branch counts,
morphology adapters, and electrophysiology are future feature work.
