#import "../lib.typ": paradigm, stage

#set page(width: 15cm, height: 5cm, margin: 0.4cm)
#set text(font: "Libertinus Sans", size: 9pt)

#figure(
  paradigm((
    stage("Fixation", duration: 1, duration-label: "1 s", display: [•]),
    stage("Target", duration: 0.6, duration-label: "600 ms", display: [■]),
    stage("Mask", duration: 1.2, duration-label: "1.2 s", display: [⋅ ⋅ ⋅\\⋅ • ⋅\\⋅ ⋅ ⋅]),
    stage("Delay", duration: 1.5, duration-label: "1.5 s", display: [•]),
    stage("Response", duration: 2, duration-label: "2 s", display: [Vu?]),
  ), spacing: "proportional", time-width: 13, panel: "rectangle", gap: 0.08),
  caption: [Proportional stage widths show relative duration],
)
