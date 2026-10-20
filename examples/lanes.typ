#import "../lib.typ": timeline, stage

#set page(width: 15cm, height: 7cm, margin: 0.5cm)
#set text(font: "Libertinus Sans", size: 9pt)

#figure(
  timeline((
    stage("Fixation", start: 0, end: 1, lane: "Task"),
    stage("Stimulus", start: 1, end: 2.5, lane: "Task"),
    stage("Response", start: 2.5, end: 4, lane: "Task"),
    stage("Image sequence", start: 1, end: 2.5, lane: "Stimulus", display: [A · B · C]),
    stage("EEG recording", start: 0, end: 4, lane: "Recording"),
    stage("Baseline", start: 0, end: 0.5, lane: "Analysis"),
    stage("Response window", start: 2.5, end: 3.5, lane: "Analysis"),
  ), layout: "lanes", time-width: 11, arrow: true),
  caption: [Task events, stimulus presentation, recording, and analysis windows],
)
