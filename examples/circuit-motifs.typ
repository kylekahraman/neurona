#import "../lib.typ": motif
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

#let motifs-figure(width: 180mm) = {
  let panel(title, kind) = stack(dir: ttb, spacing: 3mm,
    text(size: 9pt, weight: "semibold")[#title],
    motif(kind, width: 170mm / 3),
  )
  let drawing = block(width: 180mm, grid(columns: (1fr, 1fr, 1fr), column-gutter: 5mm, align: center + top,
    panel([Feedforward inhibition], "feedforward"),
    panel([Feedback inhibition], "feedback"),
    panel([Disinhibition], "disinhibition"),
  ))
  scale(x: width / 180mm * 100%, y: width / 180mm * 100%, reflow: true, drawing)
}

#motifs-figure()
