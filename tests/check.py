"""Compile public examples and verify semantic geometry and rejected bad edges."""
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
FAILURES = {
    "unknown-layer": "Unknown layer",
    "unknown-target": "Unknown neuron endpoint",
    "wrong-compartment": "Unknown compartment",
    "duplicate-region": "Region IDs must be unique",
    "conflicting-route": "Choose via or controls",
    "zero-width": "Figure width must be positive",
    "duplicate-element": "Cell and population IDs must be unique",
    "shadowed-port": "Custom port names must not shadow",
    "incomplete-cortex": "Supply six cortical heights",
    "invalid-legend-columns": "Legend columns must be a positive integer",
    "duplicate-junction": "Junction IDs must be unique across scene elements",
    "wrong-junction-port": "Unknown compartment",
}

MODEL_FAILURES = {
    "duplicate-model-id": "Diagram element IDs must be unique",
    "mixed-duplicate-id": "Diagram element IDs must be unique",
    "invalid-model-port": "Unknown compartment",
    "shadowed-model-port": "Custom diagram ports must not shadow",
    "dotted-model-port": "Custom diagram ports must not shadow",
    "negative-node-size": "Diagram node dimensions must be positive",
    "negative-group-size": "Group dimensions must be positive",
    "conflicting-model-route": "Choose via or controls",
}


def compile_file(source, output, case=None):
    command = ["typst", "compile", "--root", str(ROOT)]
    if case:
        command += ["--input", f"case={case}"]
    return subprocess.run(command + [str(source), str(output)], cwd=ROOT,
                          capture_output=True, text=True)


with tempfile.TemporaryDirectory(prefix="paradigm-check-") as directory:
    for source in sorted((ROOT / "examples").glob("*.typ")) + sorted((ROOT / "tests").glob("*.typ")) + [ROOT / "showcase.typ"]:
        result = compile_file(source, Path(directory) / f"{source.stem}.pdf")
        if result.returncode:
            raise SystemExit(result.stderr)
        print(f"PASS {source.relative_to(ROOT)}")
    for case, message in FAILURES.items():
        result = compile_file(ROOT / "tests/circuits.typ", Path(directory) / "invalid.pdf", case)
        if result.returncode == 0 or message not in result.stderr:
            raise SystemExit(f"Unexpected result for {case}:\n{result.stderr}")
        print(f"PASS rejects {case}")

    for case, message in MODEL_FAILURES.items():
        result = compile_file(ROOT / "tests/models.typ", Path(directory) / "invalid-model.pdf", case)
        if result.returncode == 0 or message not in result.stderr:
            raise SystemExit(f"Unexpected result for {case}:\n{result.stderr}")
        print(f"PASS rejects {case}")

subprocess.run(["python3", str(ROOT / "tests/visual_geometry.py")], check=True)
