# paradigm

A Typst toolkit for making time-based scientific schematics: experimental paradigms, stimulus sequences, session plans, and analysis windows. Describe phases and events once, then render them as panels, a time axis, or parallel lanes. The output is vector artwork, and displays accept ordinary Typst content.

## Quick start

```typst
#import "@preview/paradigm:0.1.0": paradigm, stage, timeline

#figure(
  paradigm((
    stage("Fixation", duration: "1 s", display: [•]),
    stage("Target", duration: "17 ms", display: [■]),
    stage("ISI", duration: "17 ms", display: [•]),
    stage("Mask", duration: "233 ms", display: [⋅  ⋅  ⋅\ ⋅  •  ⋅\ ⋅  ⋅  ⋅]),
    stage("Delay", duration: "1.5 s", display: [•]),
    stage("Response", duration: "2 s", display: [Vu?]),
  )),
  caption: [Example visual working-memory task],
)
```

## API

- `stage(title, ...)` describes an event or phase. Use `display` for any Typst content.
- `paradigm(stages, ...)` is the quick path for an experimental sequence of display panels.
- `timeline(stages, layout: ...)` selects `"panels"`, `"axis"`, or `"lanes"`.
- Panel `spacing: "equal"` keeps every stage the same width. `spacing: "proportional"` scales widths to numeric `duration` values in seconds; use `duration-label` to control the printed label.
- For `"axis"` and `"lanes"`, provide numeric `start` and `end` times in seconds. Overlapping intervals are supported. Give each parallel track a `lane` name.
- Panel shapes can be selected globally with `panel: "perspective"`, `"rectangle"`, `"diamond"`, `"circle"`, or `"none"`; a stage can override that with `shape:`.
- `stage-width`, `stage-height`, `time-width`, `gap`, `header-gap`, and `timing-gap` tune layout dimensions in cm. `arrow`, `stroke`, `fill`, `font-size`, and `line-width` tune appearance.

The easiest path needs only a list of stages and their display labels. Use numeric seconds when exact spacing matters, and use `display` for custom stimuli or illustrations. Extremely short stages can become too narrow to hold labels or artwork in proportional panels; use the time-axis layout for large differences in duration. See [the equal-spacing example](examples/working-memory.typ), [proportional panels](examples/proportional.typ), [time axis](examples/axis.typ), and [parallel lanes](examples/lanes.typ).

## Development

Compile examples from this directory:

```sh
typst compile --root . examples/working-memory.typ /tmp/paradigm.pdf
typst compile --root . examples/proportional.typ /tmp/paradigm-proportional.pdf
typst compile --root . examples/axis.typ /tmp/paradigm-axis.pdf
typst compile --root . examples/lanes.typ /tmp/paradigm-lanes.pdf
```

The package uses [CeTZ](https://cetz-package.github.io/) for vector drawing.
