#import "../lib.typ": cells, neuron, circuit, projection
#import "@preview/cetz:0.3.4"
#set page(width:auto,height:auto,margin:3mm)
#for (detail,west,east) in (("minimal",(0.56,1.25),(0.56,2.75)),("branched",(0.28,0.91),(0.28,3.09))) {
 cetz.canvas({
  cells.draw-neuron(neuron("pc",at:(3,2),apical:2,basal:0.6,spread:0.5,scale:2,orientation:90deg,detail:detail))
  cetz.draw.get-ctx(ctx=>{
   for (port,expected) in (("pc.oblique-tip-west",west),("pc.oblique-tip-east",east),("pc.basal-tip-west",(4.2,1.1)),("pc.basal-tip-east",(4.2,2.9))) {
    let (_,actual)=cetz.coordinate.resolve(ctx,port)
    for i in range(2) {assert(calc.abs(actual.at(i) - expected.at(i)) < 0.00001)}
   }
   ()
  })
 })
}
#circuit(neurons:(neuron("pc"),),connections:(projection((-3,2.3),"pc.oblique-tip-west",target-gap:0.15),projection((3,-1.1),"pc.basal-tip-east",target-gap:0.15)))
