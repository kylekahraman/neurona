---
title: Installation
description: Start with the Neurona development package in the browser or locally.
---

Neurona is a drawing toolkit for [Typst](https://typst.app/). A `.typ` file
contains the figure description; Typst compiles it into artwork.

## Download the starter

[Download Neurona starter ZIP ↓](/neurona/files/neurona-starter.zip)

Extract the download. The folder contains:

```text
neurona-starter/
├── lib.typ
├── src/
├── examples/
├── docs/
├── README.md
└── LICENSE
```

Keep `lib.typ` beside `src/`. The supplied examples import `../lib.typ` because
they live in `examples/`. This local import is the current installation method;
there is no published `@preview/neurona` release yet.

## In your browser

1. Create a blank project in the [Typst web app](https://typst.app/).
2. Upload `lib.typ`, `src/`, and `examples/`, preserving the folder structure.
3. Set `examples/01-cell.typ` as the main file to compile.
4. Edit a label or dimension and inspect the updated preview.

## On your computer

[Install the Typst CLI](https://github.com/typst/typst#installation), then open
a terminal in the extracted `neurona-starter/` folder:

```sh
typst compile --root . examples/01-cell.typ figure.pdf
```

Open `figure.pdf`. For a continuously updated PDF, run:

```sh
typst watch --root . examples/01-cell.typ figure.pdf
```

The CeTZ dependency is downloaded on first compilation, so that run needs an
internet connection.

Continue with [Your first figure](/neurona/getting-started/first-figure/).
