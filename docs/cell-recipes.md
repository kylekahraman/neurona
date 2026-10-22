# Cell recipes and circuit motifs

The `interneuron` recipes are original schematic drawings of selected rodent CA1 domains. They are not traced reconstructions, an exhaustive cell taxonomy, or human anatomical templates. The source literature supports the regional/compartment relationships, not the illustrated branching patterns, branch counts, dimensions or bouton counts. No external artwork is bundled.

## Interneuron drawings

| Recipe | Soma placement in the atlas | Colored axon territory | Selected pyramidal target in the companion diagram |
| --- | --- | --- | --- |
| `basket` | SP | Perisomatic territory around SP | Soma |
| `axo-axonic` | SP | Cartridges below the pyramidal cell layer | Axon initial segment (`ais`) |
| `bistratified` | SP | SR and SO | Apical and basal dendritic shafts |
| `olm` | SO | SLM | Distal apical tuft |

Grey paths distinguish dendrites from colored somata/axons in the atlas. Boutons are schematic distribution markers, not inferred contacts with nearby processes. These patterns represent one cell's arbor, not a network of multiple neurons. Basket terminals use open branches rather than closed mesh-like loops; the atlas includes a compact color/marker key.

The target diagram separately authors five terminal contacts. The bistratified output has one explicit axon stem and branch point, with shorter curved branches to an apical oblique dendrite and a basal dendrite. The filled point marks that axon branch, not an additional cell or synapse. Its inhibitory terminal bars are a drawing convention for these selected GABAergic pathways, not a simulation of membrane-potential-dependent effects.

The atlas uses SO/SP/SR/SLM heights of 0.9/0.4/1.4/0.9 canvas units; SP somata are centered at y=1.1 and the O-LM soma at y=0.45. These values describe a drawing recipe. `scale` and `orientation` transform the entire cell and its named ports. Changing regional layer thicknesses does not reshape the preset; use the editable `dendrites`/`axons` records or a custom cell for other domain proportions. No actual micrometre scale or density is implied.

```typst
#import "lib.typ": interneuron, neuron, projection, circuit
#circuit(
  width: 85mm,
  neurons: (
    interneuron("basket", at: (0, 0), arbor: false),
    neuron("p", at: (4, 0), apical: 2),
  ),
  connections: (
    projection("basket.axon", "p.soma-west", effect: "inhibitory"),
  ),
)
```

`interneuron(id, kind:, at:, scale:, orientation:, color:, dendrite-color:, label:, label-offset:, arbor:)` returns an ordinary custom `neuron` record. Its stable `axon` port is the end of the source axon stub; `dendrite` identifies a drawn dendritic tip. `arbor: true` uses a rightward soma exit for basket, axo-axonic and bistratified cells, and an upward exit for O-LM cells. `arbor: false` uses a downward stub for compact circuit compositions. The named `axon` port follows the displayed stub in both modes. The additional `recipe` and `anatomical-context` fields identify the schematic's source context; the common renderer ignores metadata. Ordinary custom-path ports (`axon-0`, `dendrite-0`, etc.) are also available.

Basket-like generic morphology (`neuron(kind: "basket")`) and the laminar basket recipe (`interneuron(kind: "basket")`) serve different drawing needs: the former supplies a configurable generic multipolar glyph; the latter adds a selected CA1 domain recipe. Neither assigns PV/CCK or other molecular identities automatically.

## Current customization limits

For built-in `neuron` glyphs, `apical`, `basal`, `spread`, `scale`, `orientation` and `detail` adjust dimensions, orientation and the supported detail variants. Their branching patterns still use fixed branch counts; adding `dendrites` adds paths rather than replacing those defaults. A `custom` cell supplies explicit paths instead.

`interneuron` returns an ordinary record, so its `dendrites` can be replaced with any number of explicit `neurite` paths without modifying package source. Replace the `dendrite` port too when its previous endpoint no longer lies on a drawn path. There is currently no convenience parameter for arbitrary dendrite counts or procedural arbor generation. For example:

```typst
#import "lib.typ": interneuron, neurite, circuit
#let olm = interneuron("olm", kind: "olm", arbor: false)
#let dendrites = (
  neurite(((0, 0), (-0.7, 0.15), (-1.2, 0.3)), color: rgb("667b87")),
  neurite(((0, 0), (0.8, 0.1), (1.4, -0.2)), color: rgb("667b87")),
)
#circuit(neurons: (olm + (dendrites: dendrites,
  ports: (axon: (0, -0.48), dendrite: (1.4, -0.2))),), width: 85mm)
```

Layer and neurite colors remain author-selected. `band(fill: ...)` and `cortical-layers(fills: ...)` accept grey/white fills as well as color. Routing and label placement remain explicit; `projection(target-gap: ...)` adds a terminal clearance but is not a collision-avoidance engine.

## Topological motifs

`motif("feedforward", width: 60mm)`, `motif("feedback")` and `motif("disinhibition")` render compact authored topologies with neutral excitatory/inhibitory labels. Arrowheads and terminal bars identify the explicitly selected connection convention. Molecular identity, brain region, firing rates, delays and net circuit gain are not inferred.

`motif-scene(kind)` returns the ordinary `neurons`, `populations`, `connections` and `annotations` arguments. Pass them into `circuit(..scene)` to extend the figure; no separate renderer is involved. Both functions accept `excitation` and `inhibition` colors; `motif` also accepts `width`, `font-size` and `line-width`. In disinhibition the authored inhibitory path is I1 -> I2 -> E, alongside excitatory input. This topology alone is not a quantitative claim about the response of a particular circuit.

## Primary anatomical references

- Klausberger et al. (2003), *Brain-state- and cell-type-specific firing of hippocampal interneurons in vivo*, Nature 421, 844–848. [doi:10.1038/nature01374](https://doi.org/10.1038/nature01374). Identified basket, axo-axonic and O-LM cells in rat hippocampus. [Author-hosted full text](https://www.mrcbndu.ox.ac.uk/sites/default/files/pdfs/KlausbergerNature.pdf).
- Klausberger et al. (2004), *Spike timing of dendrite-targeting bistratified cells during hippocampal network oscillations in vivo*, Nature Neuroscience 7, 41–47. [doi:10.1038/nn1159](https://doi.org/10.1038/nn1159). CA1 axonal domains in SO/SR and dendritic targets; also states the contrasting soma/AIS/distal-dendrite targets. [Corrected author-hosted full text](https://www.mrcbndu.ox.ac.uk/sites/default/files/pdf_files/klausbergernatneurosci2004.pdf).
- Leão et al. (2012), *OLM interneurons differentially modulate CA3 and entorhinal inputs to hippocampal CA1 neurons*, Nature Neuroscience 15, 1524–1530. [doi:10.1038/nn.3235](https://doi.org/10.1038/nn.3235). Mouse CA1 O-LM pathways; supports distal-target and circuit context, not the drawn geometry.
- Pouille and Scanziani (2001), *Enforcement of temporal fidelity in pyramidal cells by somatic feed-forward inhibition*, Science 293, 1159–1163. [doi:10.1126/science.1060342](https://doi.org/10.1126/science.1060342). Rat hippocampal feedforward inhibition, an experimental example of the generic topological motif. The drawing does not encode the study's measured timing.

The supplied textbook Figures 3.29, 5.33 and 7.1B motivate the visual vocabulary of laminar domains and compartment-specific connections. A first reduced [multiregion cellular circuit](hippocampal-microcircuit.md) is implemented; full cell/pathway coverage of Figure 7.1B remains future work.
