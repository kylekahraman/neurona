# Reference classes

Classify panels by drawing vocabulary rather than chapter. One figure can combine several classes. The 20 initially supplied screenshots and 19 subsequently supplied local screenshots were visually reviewed; the latter include another crop of Figure 5.4.

| Class | Shared vocabulary | References | Coverage / next extension |
| --- | --- | --- | --- |
| Cells and morphology | Soma, arbors, orientation, compartments | 3.17, 3.23, 3.26-3.28, 5.2; local 15.54.01 | Schematic glyphs/explicit paths; reconstruction adapters later |
| Laminar organization | Strata, layer positions, arbor/terminal domains | 3.18B, 3.29, 5.33B/C, 7.1B, 7.4 | Layer stacks, four CA1 interneuron recipes, target compartments and a first nine-cell DG/CA3/CA1 microcircuit supported; broader cell coverage next |
| Local circuit motifs | Excitation, inhibition, recurrence, disinhibition, electrical coupling | 7.2A, 7.10, 5.33A; local 15.54.04 | Three editable inhibitory motifs supported; recurrence and gap-junction symbols next |
| Regional connectivity | Nodes, pathways, topography, channels | 3.1B, 3.38C, 3.40, 3.56, 3.57, 7.1A; local 15.54.40, 15.55.52 | Nodes and manual routes supported; topographic geometry later |
| Anatomical frames | Sections, spatial fields, curved layers, perspective | 3.1A, 3.28, 3.31; local 15.54.56, 15.55.45 | Further geometry; brain templates are long-term |
| Illustrative signals | Stylized voltage/current, spikes, oscillation phase | 5.4, 5.40, 7.2B, 7.4 insets | Procedural illustration generators planned; experimental-data ingestion outside scope |
| Synaptic detail | Bouton, spine, shaft, multiple contacts | 3.23; local 15.56.07 | Simple boutons supported; terminal/spine geometry later |

Interventions, explanatory boxes, zooms and before/after comparisons are composition/styling operations usable across classes. They do not require separate rendering engines.

## Additional local screenshots

Files are in `/Users/kyle/Downloads/hippocampus book screenshots`; times are on 2026-10-20. Cropped figure numbers are left unspecified.

| Time | Visible content | Classes / composition |
| --- | --- | --- |
| 15.44.20 | 5.4, adaptation/bursting; another crop of an existing reference | Illustrative signals |
| 15.47.50 | Optogenetic inhibition comparison | Local motif + intervention |
| 15.52.24 | Superficial/deep principal cells, PV basket cell and regional targets | Local motif + regional connectivity |
| 15.52.31 | 7.10, local models for fast oscillations | Local motifs and electrical coupling |
| 15.52.45 | GABA receptor antagonist comparison | Local motif + intervention |
| 15.52.51 | 7.4, laminar circuits with trace insets | Laminar organization + illustrative signals |
| 15.52.58 | Current input and optogenetic inhibition | Local motif + signals + intervention |
| 15.53.04 | 7.2, elementary circuits/computations | Local motifs + illustrative signals |
| 15.53.14 | 7.1, global/local hippocampal circuit anatomy | Regional connectivity + laminar organization |
| 15.53.48 | 5.40, interneuron types and phase coupling | Laminar cell domains + illustrative signals |
| 15.54.01 | PV basket/principal-cell reconstructions with image inset | Cell morphology + image composition |
| 15.54.04 | PV basket cell and principal cells labeled by target | Local motif + regional connectivity |
| 15.54.22 | 5.33, inhibitory diversity and layer domains | Local motifs + laminar organization |
| 15.54.40 | LEC/MEC pathways, loops and functional color codes | Regional connectivity + semantic styling |
| 15.54.56 | Curved molecular/topographic fields with connectivity labels | Anatomical frame + regional connectivity |
| 15.55.37 | 5.16, CA2 plasticity and molecular explanations | Cell compartments + circuit + explanatory boxes |
| 15.55.45 | Curved hippocampal sections with CA2 pathways | Anatomical frame + regional connectivity |
| 15.55.52 | CA3 population, grouped inputs and recurrence | Regional/population connectivity |
| 15.56.07 | Single and compound synaptic contacts | Synaptic detail |

## Layer interpretation

The neocortical preset uses stable IDs `l1`-`l6`; roman/Arabic numbering changes labels only. Specific areas can use modified stacks or subdivisions. CA1, CA3 and DG retain their own strata. Archicortex being broadly three-layered does not imply collapsing the named strata used to locate hippocampal arbors and terminals.

Anatomical sources: [Palomero-Gallagher et al. (2020)](https://doi.org/10.1007/s00429-019-02022-4), [Ohara et al. (2018)](https://pubmed.ncbi.nlm.nih.gov/29972772/) and [Ohara et al. (2023)](https://pubmed.ncbi.nlm.nih.gov/36680772/). The latter demonstrates differing hippocampal-entorhinal target sublayers along the dorsoventral axis.
