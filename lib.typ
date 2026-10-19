#import "@preview/cetz:0.3.4": canvas

/// Describe one stage in an experimental sequence.
///
/// The display can be any Typst content, so stimulus sketches stay editable.
#let stage(title, duration: none, display: none) = (
  title: title,
  duration: duration,
  display: display,
)

/// Draw a horizontal sequence of experimental stages with labels and timings.
///
/// `stage-width` and `stage-height` are in centimeters. `gap` can be negative
/// to create the overlapping-screen look used in many paradigm figures.
#let paradigm(
  stages,
  stage-width: 2.05,
  stage-height: 1.62,
  gap: -0.58,
  header-gap: 0.18,
  timing-gap: 0.20,
  panel: "perspective",
  arrow: true,
  font-size: 9pt,
  line-width: 0.8pt,
  stroke: black,
  fill: white,
) = {
  assert(stages.len() > 0, message: "paradigm requires at least one stage")
  assert(panel == "perspective" or panel == "rectangle", message: "panel must be 'perspective' or 'rectangle'")

  let step = stage-width + gap
  let total-width = stage-width + (stages.len() - 1) * step
  let top = stage-height
  let header-y = top + header-gap + 0.28
  let timing-y = -timing-gap - 0.28
  let line-y = timing-y - 0.30
  let arrow-end = total-width

  canvas(length: 1cm, {
    import cetz.draw: *

    for (i, item) in stages.enumerate() {
      let x = i * step
      let cx = x + stage-width / 2
      let title = if type(item.title) == str { item.title } else { item.title }
      let p0 = (x, 0)
      let p1 = (x + 0.10, top)
      let p2 = (x + stage-width, top - 0.02)
      let p3 = (x + stage-width - 0.10, -0.30)

      if panel == "perspective" {
        line(p0, p1, p2, p3, close: true, stroke: (paint: stroke, thickness: line-width), fill: fill)
      } else {
        rect((x, -0.30), (x + stage-width, top), stroke: (paint: stroke, thickness: line-width), fill: fill)
      }

      content((cx, header-y), text(size: font-size, weight: "bold", align: center)[#title], anchor: "south")
      if item.display != none {
        content((cx, top / 2 - 0.12), item.display)
      }
      if item.duration != none {
        content((cx, timing-y), text(size: font-size)[#item.duration], anchor: "north")
      }
    }

    if arrow {
      line((-0.15, line-y), (arrow-end + 0.15, line-y), stroke: (paint: stroke, thickness: line-width), mark: (end: "stealth", start: "circle"))
    }
  })
}
