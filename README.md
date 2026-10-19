# paradigm

A small Typst toolkit for making experimental paradigm timelines. Describe
stages in order, provide labels and durations, and place ordinary Typst content
inside each display panel. The diagram is vector output and remains editable at
the source level.

## Quick start

```typst
#import "@preview/paradigm:0.1.0": paradigm, stage

#figure(
  paradigm((
    stage("Fixation", duration: "1 s", display: [•]),
    stage("Target", duration: "17 ms", display: [•]),
    stage("ISI", duration: "17 ms", display: [•]),
    stage("Mask", duration: "233 ms", display: [⋅  ⋅  ⋅\ ⋅  •  ⋅\ ⋅  ⋅  ⋅]),
    stage("Delay", duration: "1.5 s", display: [•]),
    stage("Response", duration: "2 s", display: [Vu?]),
  )),
  caption: [Example visual working-memory task],
)
```

## API

- `stage(title, duration: none, display: none)` describes a single step.
- `paradigm(stages, ...)` lays stages out horizontally with a timeline arrow.
- `stage-width`, `stage-height`, `gap`, `header-gap`, and `timing-gap` are in cm.
  A negative `gap` produces overlapping panels.
- `panel: "perspective"` (default) or `"rectangle"` sets the panel outline.
- `arrow: false` hides the timeline arrow. `stroke`, `fill`, `font-size`, and
  `line-width` tune the visual style.

`display` accepts Typst content, so use text, math, shapes, or small inline
figures. This MVP focuses on ordered stages; branching and multi-row designs
are future directions.

## Development

Compile the example from this directory:

```sh
typst compile examples/working-memory.typ /tmp/paradigm.pdf
```

The package uses [CeTZ](https://cetz-package.github.io/) for vector drawing.
