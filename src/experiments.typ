#import "@preview/cetz:0.3.4"

/// Describe a phase or event in a scientific timeline.
///
/// `duration` is a display label in the equal-spacing panel layout, or a
/// numeric duration in seconds for proportional timelines. `start` and `end`
/// are seconds from the start of the experiment and allow overlapping phases.
/// `display` accepts any Typst content; `lane` places phases on parallel rows.
#let stage(
  title,
  duration: none,
  duration-label: none,
  display: none,
  start: none,
  end: none,
  lane: "main",
  shape: none,
) = (
  title: title,
  duration: duration,
  duration-label: duration-label,
  display: display,
  start: start,
  end: end,
  lane: lane,
  shape: shape,
)

/// Draw a research timeline using panel, axis, or lane-based layouts.
///
/// Layouts are `"panels"`, `"axis"`, or `"lanes"`. Panel spacing can be
/// `"equal"` or `"proportional"`; proportional durations and axis/lane times
/// are numeric seconds. A negative `gap` creates overlapping panels.
#let timeline(
  stages,
  layout: "panels",
  spacing: "equal",
  stage-width: 2.05,
  stage-height: 1.62,
  time-width: 12,
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
  assert(stages.len() > 0, message: "timeline requires at least one stage")
  assert(layout in ("panels", "axis", "lanes"), message: "layout must be 'panels', 'axis', or 'lanes'")
  assert(spacing in ("equal", "proportional"), message: "spacing must be 'equal' or 'proportional'")
  assert(panel in ("perspective", "rectangle", "diamond", "circle", "none"), message: "unknown panel shape")
  assert(stage-width > 0 and stage-height > 0 and time-width > 0, message: "timeline dimensions must be positive")

  let timed = layout != "panels" or spacing == "proportional"
  let positioned = ()
  let elapsed = 0
  let max-time = 0
  let lane-names = ()

  for item in stages {
    let has-numeric-duration = type(item.duration) == int or type(item.duration) == float
    if timed {
      assert(item.start != none or has-numeric-duration, message: "axis and proportional layouts need numeric duration values in seconds")
      assert(item.end != none or has-numeric-duration, message: "provide an end time or a numeric duration in seconds")
    }
    if layout == "lanes" {
      assert(item.start != none, message: "lane layouts need explicit start times in seconds")
    }
    let start = if item.start != none { item.start } else { elapsed }
    let end = if item.end != none { item.end } else if has-numeric-duration { start + item.duration } else { start + 1 }
    assert(end >= start, message: "stage end must be at or after its start")
    positioned.push(item + (start: start, end: end))
    elapsed = calc.max(elapsed, end)
    max-time = calc.max(max-time, end)
    if not lane-names.contains(item.lane) {
      lane-names.push(item.lane)
    }
  }
  assert(not timed or max-time > 0, message: "timeline duration must be greater than zero")
  if layout == "lanes" {
    for item in positioned {
      assert(item.start != none and item.end != none, message: "lane layouts need explicit start/end times or numeric durations")
    }
  }

  let panel-positions = ()
  let panel-gap = if spacing == "proportional" and gap < 0 { 0.08 } else { gap }
  let panel-x = 0
  for item in positioned {
    let width = if spacing == "proportional" {
      (item.end - item.start) / max-time * time-width
    } else {
      stage-width
    }
    panel-positions.push((x: panel-x, width: width))
    panel-x += width + panel-gap
  }
  let timing-y = -timing-gap - 0.28
  let line-y = timing-y - 0.30 - (if spacing == "proportional" { 0.42 } else { 0 })

  cetz.canvas(length: 1cm, {
    import cetz.draw: circle, content, line, mark, rect

    if layout == "panels" {
      // Draw from right to left: earlier screens sit in front of later ones.
      for offset in range(positioned.len()) {
        let i = positioned.len() - offset - 1
        let item = positioned.at(i)
        let pos = panel-positions.at(i)
        let x = pos.x
        let width = pos.width
        let top = stage-height
        let shape = if item.shape == none { panel } else { item.shape }
        if shape == "perspective" {
          line((x, 0), (x + 0.10, top), (x + width, top - 0.02), (x + width - 0.10, -0.30), close: true, stroke: (paint: stroke, thickness: line-width), fill: fill)
        } else if shape == "rectangle" {
          rect((x, -0.30), (x + width, top), stroke: (paint: stroke, thickness: line-width), fill: fill)
        } else if shape == "diamond" {
          line((x + width / 2, top), (x + width, top / 2), (x + width / 2, -0.30), (x, top / 2), close: true, stroke: (paint: stroke, thickness: line-width), fill: fill)
        } else if shape == "circle" {
          circle((x + width / 2, top / 2 - 0.15), radius: calc.min(width / 2, (top + 0.30) / 2), stroke: (paint: stroke, thickness: line-width), fill: fill)
        }
      }

      for (i, item) in positioned.enumerate() {
        let pos = panel-positions.at(i)
        let x = pos.x
        let width = pos.width
        let cx = x + width / 2
        let label-row = if spacing == "proportional" and width < 0.75 { calc.rem(i, 2) } else { 0 }
        let header-y = stage-height + header-gap + 0.28 + label-row * 0.38
        let duration-y = timing-y - label-row * 0.30
        let duration = if item.duration-label != none { item.duration-label } else { item.duration }
        content((cx, header-y), align(center, text(size: font-size, weight: "bold")[#item.title]), anchor: "south")
        if item.display != none {
          content((cx, stage-height / 2 - 0.12), item.display)
        }
        if duration != none {
          content((cx, duration-y), text(size: font-size)[#duration], anchor: "north")
        }
      }

      if arrow {
        line((-0.15, line-y), (panel-x - panel-gap + 0.15, line-y), stroke: (paint: stroke, thickness: line-width))
        circle((-0.15, line-y), radius: 0.035, fill: stroke, stroke: none)
        mark((panel-x - panel-gap + 0.15, line-y), 0deg, symbol: ">", scale: 1.4, stroke: black)
      }
    } else {
      // Real-time layouts use a common scale, so parallel tracks line up.
      let scale = time-width / max-time
      let top = if layout == "axis" { 1.35 } else { lane-names.len() * 1.2 }
      let bottom = if layout == "axis" { -0.85 } else { -0.35 }

      for (lane-index, lane-name) in lane-names.enumerate() {
        let y = top - lane-index * 1.2
        line((0, y), (time-width, y), stroke: (paint: luma(190), thickness: 0.45pt))
        if layout == "lanes" {
          content((-0.18, y), text(size: font-size)[#lane-name], anchor: "east")
        }
      }

      for item in positioned {
        let lane-index = 0
        if layout == "lanes" {
          for (index, lane-name) in lane-names.enumerate() {
            if lane-name == item.lane {
              lane-index = index
            }
          }
        }
        let y = top - lane-index * 1.2
        let x0 = item.start * scale
        let x1 = item.end * scale
        if x1 == x0 {
          line((x0, y - 0.18), (x0, y + 0.18), stroke: (paint: stroke, thickness: 1.2pt))
          circle((x0, y), radius: 0.055, fill: fill, stroke: (paint: stroke, thickness: line-width))
        } else {
          rect((x0, y - 0.18), (x1, y + 0.18), stroke: (paint: stroke, thickness: line-width), fill: fill)
        }
        content(((x0 + x1) / 2, y + 0.33), align(center, text(size: font-size, weight: "bold")[#item.title]), anchor: "south")
        if item.display != none {
          content(((x0 + x1) / 2, y), item.display)
        }
        let duration = if item.duration-label != none { item.duration-label } else if type(item.duration) == str { item.duration } else { none }
        if duration != none {
          content(((x0 + x1) / 2, y - 0.28), text(size: font-size * 0.9)[#duration], anchor: "north")
        }
      }

      if arrow {
        line((0, bottom), (time-width + 0.15, bottom), stroke: (paint: stroke, thickness: line-width))
        circle((0, bottom), radius: 0.035, fill: stroke, stroke: none)
        mark((time-width + 0.15, bottom), 0deg, symbol: ">", scale: 1.4, stroke: black)
      }
    }
  })
}

/// Draw the familiar experimental-screen sequence layout.
///
/// This convenience wrapper is equivalent to `timeline(..., layout: "panels")`.
#let paradigm(stages, ..args) = timeline(stages, layout: "panels", ..args)
