# Open illustration candidates

Reviewed on 2026-10-20. These are integration candidates; no third-party artwork is currently bundled with the package or used in `showcase.png`.

| Source | Confirmed scope | License evidence | Integration opportunity |
| --- | --- | --- | --- |
| [NeuroSVG](https://github.com/MartinPyka/NeuroSVG) | The maintainer describes a rat hippocampus/entorhinal-cortex SVG with axonal and dendritic morphologies | Repository README states CC BY 4.0 for all SVG files | A particularly relevant candidate for an anatomical frame or detailed vector drawing; inspect the actual SVG before integration |
| [Bioicons](https://bioicons.com/) / [repository](https://github.com/duerrsimon/bioicons) | Scientific SVG library, including cell, nervous-system and anatomical assets | Individual assets have individual licenses; site provides CC0, CC BY, CC BY-SA, MIT and other filters; repository code's MIT license is not a blanket license for every image | Start with individually verified CC0/MIT illustrations, or attributed CC BY assets; select a small coherent set |
| [Servier Medical Art](https://smart.servier.com/) | Explicit brain, neural-cell and synapse categories | Provider's current site states CC BY 4.0, permits adaptation and sharing with creator credit | Ready-made anatomical and synaptic illustrations, suitable for optional asset panels |
| [SciDraw](https://scidraw.io/) | Scientific illustration repository; indexed listing includes pyramidal-neuron SVGs | Indexed provider description lists CC BY or CC0; individual asset/license inspection remains pending because the current site renders dynamically | Candidate detailed neurons and experimental equipment; not yet selected for bundling |

## NeuralSVG is a different kind of tool

[NeuralSVG](https://github.com/SagiPolaczek/NeuralSVG) is a general text-to-vector generation research project, distinct from NeuroSVG's anatomical drawings. Its [ICCV 2025 paper](https://openaccess.thecvf.com/content/ICCV2025/html/Polaczek_NeuralSVG_An_Implicit_Representation_for_Text-to-Vector_Generation_ICCV_2025_paper.html) describes generating layered SVGs from text prompts; the repository code is MIT licensed. It is not a curated neuroscience component library. Generated artwork could be manually reviewed as illustration input, but does not supply verified strata, cell identities or synaptic connectivity.

Given the current style preference, native, consistent cell/circuit recipes take priority. NeuroSVG remains a candidate for rodent anatomy; Bioicons and Servier are background options rather than the main visual style.

## Integration approach

Use the existing coordinate/annotation model rather than another scene renderer. An asset adapter would place an attributed SVG and expose explicit author-supplied landmarks/ports; a static picture alone does not provide soma, compartment or atlas coordinates. Templates need species and view metadata. Detailed reconstructed cells remain a separate morphology-adapter task.

For each adopted file, retain source URL and revision, author, exact license text/link, modification history and attribution text. Preserve that file's terms when distributing it with the MIT-licensed toolkit. Avoid treating a website's software license as the license of all its images.

The immediate priority remains easy-to-use native cell/layer/circuit recipes. Open SVGs can complement those with anatomy or terminal details that would otherwise require extensive new drawing work.
