#import "../lib.typ": paradigm, stage
#set page(width: auto, height: auto, margin: 3mm)

#paradigm((
  stage("Fixation", duration: "1 s", display: [•]),
  stage("Target", duration: "100 ms", display: [■]),
  stage("Delay", duration: "1.5 s", display: [•]),
  stage("Response", duration: "2 s", display: [?]),
))
