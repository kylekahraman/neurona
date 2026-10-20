#import "../lib.typ": timeline, stage

#set page(width: 15cm, height: 5cm, margin: 0.5cm)
#set text(font: "Libertinus Sans", size: 9pt)

#figure(
  timeline((
    stage("Baseline", start: 0, end: 0.5, duration-label: "−500 to 0 ms"),
    stage("Stimulus", start: 0.5, end: 0.517, duration-label: "17 ms", display: [●]),
    stage("Mask", start: 0.517, end: 0.75, duration-label: "233 ms"),
    stage("Analysis window", start: 0.6, end: 1.1, duration-label: "500 ms"),
  ), layout: "axis", time-width: 12),
  caption: [Events and analysis intervals on a shared time axis],
)
