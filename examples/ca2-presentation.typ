#import "../lib.typ": band, region, site, neuron, population, junction, projection, annotation, circuit
#import sys: inputs
#set page(width: auto, height: auto, margin: 3mm)
#set text(font: "Arial", size: 10pt)
#let exc = rgb("b56848")
#let inh = rgb("536da2")
#let ink = rgb("193348")
#let accent = rgb("268b89")
#let quiet = rgb("727f88")
#let ex(a, b, color: exc, ..args) = projection(a, b, color: color, target-gap: 0.27, ..args)
#let it(a, b, ..args) = projection(a, b, color: inh, effect: "inhibitory", target-gap: 0.23, ..args)
#let stem(a, b, color: exc, ..args) = projection(a, b, color: color, effect: "unspecified", ..args)
#let laminae = (
  band("so", label: [SO], height: 1.1, fill: rgb("f2f4f6")),
  band("sp", label: [SP], height: 1.3, fill: rgb("dfe8eb")),
  band("sr", label: [SR], height: 2.2, fill: rgb("f6f7f8")),
  band("slm", label: [SLM], height: 1.2, fill: rgb("eaf0f2")),
)
#let ca3-laminae = (
  laminae.at(0), laminae.at(1),
  band("sl", label: [SL], height: 0.6, fill: rgb("edf0f0")),
  band("sr", label: [SR], height: 1.6, fill: rgb("f6f7f8")),
  laminae.at(3),
)
#let pc(id, x, y, color: ink) = neuron(id, at: (x,y), apical: 3.55,
  basal: 1.05, spread: 0.55, color: color, ports: (mf: (0,0.85)))
#let in-cell(id, x, y) = neuron(id, at: (x,y), kind: "basket", apical: 1.0,
  basal: 0.45, spread: 0.4, color: inh)
#let mode = inputs.at("mode", default: "overview")
#if mode == "overview" {
  circuit(width: 210mm, font-size: 12.5pt, line-width: 1.3pt,
    regions: (
      region("ca3", ca3-laminae, at: (0,0), width: 5, label: [CA3]),
      region("ca2", laminae, at: (7,0), width: 5, label: [CA2]),
      region("ca1", laminae, at: (14,0), width: 7.2, label: [CA1]),
    ),
    neurons: (
      pc("p3",3.2,1.75), pc("p2",10.2,1.75,color: accent),
      pc("sup",16.0,2.05), pc("deep",19.1,1.45,color: accent),
      in-cell("i3",1.5,1.75), in-cell("i2",8.5,1.75),
    ),
    populations: (
      population("ec2ca3",[EC II],at:(3.7,6.85),width:2.0,height:0.6,color:ink),
      population("ec2",[EC II],at:(10.8,6.85),width:2.0,height:0.6,color:accent),
      population("ec3",[EC III],at:(17.5,6.85),width:2.0,height:0.6,color:ink),
    ),
    junctions: (
      junction("o3",at:(3.2,0.65),color:exc),
      junction("o2",at:(10.2,0.65),color:accent),
      junction("b3",at:(0.7,4.164),color:accent),
      junction("b2",at:(7.8,4.164),color:exc),
      junction("sc",at:(14.3,0.0),color:exc),
      junction("ecout",at:(17.5,6.25),color:exc),
      junction("ca1out",at:(15.0,-0.7),color:accent),
    ),
    connections: (
      ex("ec2ca3.south","p3.tuft"),
      ex("ec2.south","p2.tuft"),
      stem("ec3.south","ecout.center"),
      ex("ecout.center","sup.tuft"),
      ex("ecout.center","deep.tuft",controls:((20.4,6.25),(20.4,5.0))),
      stem("p3.axon","o3.center"),
      stem("o3.center","sc.center",via:((3.2,-1.5),(14.3,-1.5))),
      ex("sc.center","sup.oblique-tip-west",via:((14.3,4.464),)),
      ex("sc.center","deep.oblique-tip-west",via:((17.9,0.0),(17.9,3.864))),
      stem("o3.center","b2.center",via:((3.2,-0.4),(7.25,-0.4),(7.25,4.164))),
      ex("b2.center","p2.oblique-tip-west"),
      ex("b2.center","i2.dendrite-top"),
      it("i2.axon","p2.soma-west",controls:((9.3,0.9),(9.6,1.75))),
      stem("p2.axon","o2.center",color:accent),
      stem("o2.center","ca1out.center",via:((10.2,-0.7),),color:accent),
      ex("ca1out.center","deep.basal-tip-east",via:((20.7,-0.7),(20.7,0.4)),weight:1.5,color:accent),
      ex("ca1out.center","sup.basal-tip-east",via:((17.4,-0.7),(17.4,1.0)),weight:0.55,dashed:true,color:accent),
      stem("o2.center","b3.center",via:((10.2,-1.05),(0.25,-1.05),(0.25,4.164)),color:accent),
      ex("b3.center","p3.oblique-tip-west",color:accent),
      ex("b3.center","i3.dendrite-top",color:accent),
      it("i3.axon","p3.soma-west",controls:((2.3,0.9),(2.6,1.75))),
    ),
    annotations: (
      annotation((1.5,0.5),[IN],color:inh),
      annotation((8.5,0.5),[IN],color:inh),
      annotation((16.0,-0.3),[Superficial],color:ink),
      annotation((19.1,-0.3),[Deep],color:accent),
      annotation((6.1,-1.95),[Direct CA3 → CA1],color:exc),
      annotation((17.1,-1.15),[CA2 → CA1],color:accent),
      annotation((3.5,-2.6),[Arrow: excitation],color:exc),
      annotation((10.5,-2.6),[Bar: inhibition],color:inh),
      annotation((17.9,-2.6),[Dashed: weaker CA2 input],color:quiet),
    ),
  )
} else if mode == "ca3ca2" {
  circuit(width: 150mm,font-size:12.5pt,line-width:1.4pt,
    regions:(
      region("ca3",ca3-laminae,at:(0,0),width:5,label:[CA3]),
      region("ca2",laminae,at:(7,0),width:5,label:[CA2]),
    ),
    neurons:(pc("p3",3.2,1.75),pc("p2",10.2,1.75,color:accent),in-cell("i3",1.5,1.75),in-cell("i2",8.5,1.75)),
    junctions:(junction("o3",at:(3.2,0.65),color:exc),junction("o2",at:(10.2,0.65),color:exc),junction("b3",at:(0.7,4.164),color:exc),junction("b2",at:(7.8,4.164),color:exc)),
    connections:(
      stem("p3.axon","o3.center"),stem("p2.axon","o2.center"),
      stem("o3.center","b2.center",via:((3.2,-0.4),(7.25,-0.4),(7.25,4.164))),
      ex("b2.center","p2.oblique-tip-west"),ex("b2.center","i2.dendrite-top"),
      it("i2.axon","p2.soma-west",controls:((9.3,0.9),(9.6,1.75))),
      stem("o2.center","b3.center",via:((10.2,-1.05),(0.25,-1.05),(0.25,4.164))),
      ex("b3.center","p3.oblique-tip-west"),ex("b3.center","i3.dendrite-top"),
      it("i3.axon","p3.soma-west",controls:((2.3,0.9),(2.6,1.75))),
      projection("o3.center","p3.oblique-tip-east",via:((6.0,0.65),(6.0,4.164)),color:quiet,target-gap:0.18),
    ),
    annotations:(annotation((1.5,0.5),[IN],color:inh),annotation((8.5,0.5),[IN],color:inh),
      annotation((3.5,-1.65),[CA3 recurrence],color:quiet),
      annotation((2.3,-2.35),[Arrow: excitation],color:exc),annotation((9.3,-2.35),[Bar: inhibition],color:inh)),
  )
} else {
  circuit(width:112mm,font-size:12.5pt,line-width:1.4pt,
    regions:(region("ca2",laminae,at:(3.4,0),width:5.7,label:[CA2]),),
    populations:(population("ca3",[CA3 input],at:(0.8,4.2),width:2.3,height:0.7,color:ink),),
    neurons:(pc("p2",6.8,1.75,color:accent),in-cell("pv",4.6,1.75)),
    junctions:(junction("branch",at:(3.9,4.164),color:exc),),
    connections:(stem("ca3.east","branch.center"),ex("branch.center","p2.oblique-tip-west"),
      ex("branch.center","pv.dendrite-top"),it("pv.axon","p2.soma-west",controls:((5.3,0.9),(6.2,1.75)))),
    annotations:(annotation((4.6,-0.45),[PV⁺],color:inh),annotation((7.4,-0.45),[CA2 pyramidal cell],color:accent),),
  )
}
