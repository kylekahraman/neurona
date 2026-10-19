#import "../lib.typ": paradigm, stage

#set page(width: 16cm, height: 6cm, margin: 0.35cm)
#set text(font: "Libertinus Sans", size: 9pt)

#figure(
  paradigm((
    stage("Fixation", duration: "1 s", display: [•]),
    stage("Target", duration: "17 ms", display: [•]),
    stage("ISI", duration: "17 ms", display: [•]),
    stage("Mask", duration: "233 ms", display: [⋅  ⋅  ⋅\ ⋅  •  ⋅\ ⋅  ⋅  ⋅]),
    stage("Delay 1", duration: "1.5 s", display: [•]),
    stage("Delay 2", duration: "1.5 s", display: [G]),
    stage("Location\response", duration: "2.5–3 s", display: [•]),
    stage("Visibility\response", duration: "2 s", display: [Vu?]),
  ), stage-width: 2.1, stage-height: 1.7, gap: -0.63),
  caption: [Example experimental paradigm sequence],
)
