---
name: diagram
description: Create diagrams as SVG rendered to PNG using Python scripts. TRIGGER when: user asks for a diagram, visualization, architecture diagram, data model, request flow, sequence diagram, hierarchy, state machine, or component overview. Covers generation, rendering, and self-verification of the rendered image.
---

# Diagram Skill

## Purpose

Produce accurate diagrams as SVG (hand-computed geometry, generated deterministically by a Python script), rendered to PNG and visually verified before delivery. Optimize for comprehension and correctness, not decoration. The PNG is not just an output format: it is the verification loop. Never deliver an unverified diagram.

## Workflow

1. **Understand the source**
   - Extract components, entities, fields, relationships, constraints, and flows.
   - Preserve names, types, optionality, cardinality, direction, and business rules.
   - Never invent components, relationships, or constraints.
   - Ask a question only when missing information materially affects correctness.

2. **Choose the representation**
   - Data models: entity boxes with fields, keys, and labeled relationships.
   - Architecture / request flows: boxes, boundaries, directed arrows, protocols as arrow labels.
   - Sequences: participant headers with horizontal ordered exchanges.
   - Hierarchies: top-down trees. State machines: states with labeled transitions.
   - One concern per diagram. Split structure / data / behavior into separate diagrams when they mix.
   - When splitting, lead with a small overview diagram, then each detail diagram, all titled.

3. **Write a Python script that emits the SVG**
   - The script is the source of truth.	the SVG and PNG are build artifacts.
   - Fix issues by editing the script and regenerating. Never hand-edit a generated .svg.
   - Compute geometry in the script (coordinates from box sizes, not magic numbers scattered in strings).
   - A small constant (unit grid, stroke width) beats a clever one.

4. **Render to PNG**
   - No dependencies needed: `magick <name>.svg <name>.png`
   - Use the verified-supported SVG feature set below; unsupported constructs silently disappear.

5. **Verify visually, then iterate**
   - Read the generated PNG back (it is an image; you can inspect it).
   - Fix overlaps, clipping, misaligned connectors, wrong directions, and re-render until clean.

## File conventions

- Default location: a `diagrams/` directory in the target project (`diagrams/<name>.py`, `<name>.svg`, `<name>.png`). Ask if the project already has a different diagram convention.
- Name by content, not by number: `auth-flow.py`, not `diag2.py`.
- Deliver by referencing the PNG (and mention the SVG for editable sources). ASCII approximations are never a substitute output; do not also generate ASCII unless explicitly requested.

## SVG constraints (plain attributes only)

ImageMagick's built-in SVG renderer supports these (all verified) and struggles with exotic SVG:

**Allowed:** `rect` (including `rx` for rounded corners), `line`, `polygon`, `path` (simple ones), `text` (with `text-anchor`), `circle`, `ellipse`, `defs`/`marker` for arrowheads, `stroke-dasharray`, `opacity` and group `opacity`, plain fills/strokes.

**Forbidden (renders wrong or silently dropped):** CSS classes or `<style>` blocks — every attribute inline; `foreignObject`; `filter` effects; `tspan` for rich layout — one text element per line, positioned directly; null `font-family`.

- Always declare `viewBox` with explicit margins and an explicit opaque background: `<rect ... fill="white"/>` first, or the PNG comes back transparent.
- Define the arrowhead `marker` once in `defs`, reference with `marker-end="url(#arrow)"`. For thick/short arrows where markers misbehave, draw the head as a `polygon`.
- Target width ≤ 900 viewBox units for a single diagram; split instead of shrinking labels.
- Fonts: `font-family="Liberation Sans, DejaVu Sans, sans-serif"` (both installed).

## Text metrics (the main source of overlap bugs)

SVG text has unknown exact width. Use conservative estimates and never rely on rendering:

- Estimate average character width as ~0.6 × font-size (bold ~0.65, digits ~0.55).
- Box width ≥ text width + 2 × padding, padding ≥ 16 (12 for small labels).
- Prefer `text-anchor="middle"` on a computed box center over left-aligned guesses off box edges.
- One text line per `text` element. For multi-line labels, emit each line as its own `text` with computed `y` (line height ≈ font-size × 1.4).
- Min gap between boxes: 48 horizontal / 40 vertical. Min gap between a label and an unrelated edge: 12.
- If in doubt, make it bigger and verify the PNG.

## Verification checklist (read the PNG and check)

- No text clipped by or overflowing its box; no two labels overlapping.
- Every connector starts and ends on box edges (not floating, not crossing over boxes).
- Arrow direction and any labels match the actual data/control flow.
- Cardinality / multiplicity labels correct and legible.
- Related boxes grouped; boundaries drawn where meaningful; consistent border and arrow styles across diagrams in the same set.

## Design rules (carry over, condensed)

- Left-to-right for pipelines; top-to-bottom for layered systems.
- Crossing lines are a signal to restructure the layout, not a fact to accept.
- Distinguish containment (nested boxes) from dependency (arrows). Distinguish sync (solid) from async (dashed) arrows and say the meaning once in label text.
- Keys: mark PK, FK, nullable with `?`, keep field names verbatim from source.
- Never remove validation details (e.g. `id (PK, FK)`) to make the diagram prettier.

## Renderer fallback

If `magick` is unavailable or produces clearly broken output (missing shapes, black regions), install `cairosvg` in a disposable venv and rerun:

```bash
python3 -m venv /tmp/opencode/svgvenv
/tmp/opencode/svgvenv/bin/pip install --quiet cairosvg
/tmp/opencode/svgvenv/bin/python -m cairosvg <name>.svg -o <name>.png
```
