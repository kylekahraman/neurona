---
title: Experiments API
description: Stage records, panel sequences, time axes, and event lanes.
---

## stage

```typst
stage(title, duration: none, duration-label: none, display: none,
  start: none, end: none, lane: "main", shape: none)
```

| Parameter | Meaning |
| --- | --- |
| `title` | Stage heading |
| `duration` | Display label for equal panels, or numeric seconds for timed layouts |
| `duration-label` | Explicit printed duration text |
| `display` | Any Typst content to show as the stimulus |
| `start`, `end` | Numeric seconds on the timeline |
| `lane` | Named track in a lane layout |
| `shape` | Per-stage override of the panel shape |

## timeline

```typst
timeline(stages, layout: "panels", spacing: "equal",
  stage-width: 2.05, stage-height: 1.62, time-width: 12,
  gap: -0.58, header-gap: 0.18, timing-gap: 0.20,
  panel: "perspective", arrow: true, font-size: 9pt,
  line-width: 0.8pt, stroke: black, fill: white)
```

`stages` must be a nonempty tuple of `stage` records.

| Layout | Timing inputs | Use |
| --- | --- | --- |
| `panels`, equal spacing | Duration may be a label | A readable sequence of stimulus screens |
| `panels`, proportional spacing | Numeric duration or numeric start/end | Width represents duration |
| `axis` | Numeric start/end or numeric duration | Intervals on a shared time axis |
| `lanes` | Explicit numeric start, plus end or duration | Parallel tracks with possible overlap |

Timing values are in **seconds**. Dimensions such as `stage-width`,
`stage-height`, `gap`, and `time-width` are numeric **centimetres**;
`font-size` and `line-width` use Typst lengths.

- `panel`: `perspective`, `rectangle`, `diamond`, `circle`, or `none`.
- `gap`: spacing between panels; negative values overlap them.
- `header-gap`, `timing-gap`: offsets for panel headings and timing labels.
- `time-width`: drawing width used by numeric time layouts.
- `arrow`: show the time-direction arrow.
- `stroke`, `fill`: line and panel colors.

## paradigm

```typst
paradigm(stages, ..args)
```

A shortcut for `timeline(stages, layout: "panels", ..args)`. Pass other
panel and style parameters as named arguments.

See [Experiments and timelines](/neurona/guides/timelines/) for rendered
examples of all three layouts.
