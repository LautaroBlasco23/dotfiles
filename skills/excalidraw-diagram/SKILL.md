---
name: excalidraw-diagram
slug: excalidraw-diagram
description: >-
  Create Excalidraw-style architecture/flow diagrams authored as code
  (.excalidraw JSON), rendered to SVG + PNG, with named style presets
  (minimal, hand-drawn, detailed) and color palettes.
  TRIGGER when: user asks for an architecture diagram, flow diagram,
  box-and-arrow diagram, or mentions excalidraw / diagrams-as-code.
  DO NOT TRIGGER for mermaid or other diagram syntaxes.
---

# Excalidraw Diagrams

Generate `.excalidraw` JSON with a throwaway Python script, render to SVG/PNG,
view the PNG, iterate until clean. The `.excalidraw` file is the source of
truth; commit it alongside the rendered outputs.

## Workflow

1. Ask or decide: style preset + palette (see below). Default: `hand-drawn` + `excalidraw`.
2. Write a Python generator script (helpers below) that emits the `.excalidraw` file.
3. Render to SVG and PNG (commands below).
4. View the PNG. Fix overlaps, label overflow, arrow crossings. Re-render.
5. Repeat until clean, then present. Commit `.excalidraw` + `.svg` + `.png` together.

## Style presets

Set these as defaults in the generator's `_base()`:

| Preset | roughness | fillStyle | fontFamily | strokeWidth | Use for |
|---|---|---|---|---|---|
| `hand-drawn` | 1 | hachure | 1 | 2 | Default sketch look |
| `minimal` | 0 | transparent | 2 | 1 | Clean technical look |
| `detailed` | 1 | hachure | 1 | 2 | hand-drawn + dashed boundary containers, arrow labels, legend, multi-line text |

`detailed` is `hand-drawn` plus composition conventions, not different defaults:
dashed rectangles (`strokeStyle: "dashed"`, no fill) as system boundaries,
labels on arrows, a legend block, multi-line text (`\n`) for component details.

## Palettes

Any hex works. Named palettes — pick stroke + fill pairs from one row:

| Palette | Strokes | Fills |
|---|---|---|
| `excalidraw` (default) | `#1e1e1e` `#e03131` `#2f9e44` `#1971c2` `#f08c00` | `#ffc9c9` `#b2f2bb` `#a5d8ff` `#ffec99` `#d0bfff` |
| `catppuccin` | `#d20f39` `#40a02b` `#1e66f5` `#df8e1d` `#8839ef` | `#f5d5d8` `#dcefd8` `#d3e2fb` `#f7e6cd` `#e6d9f7` |
| `nord` | `#bf616a` `#a3be8c` `#5e81ac` `#ebcb8b` `#b48ead` | `#e5e0d5` `#dbe4d0` `#d5dfeb` `#ece4d0` `#e2d8e0` |
| `gruvbox` | `#cc241d` `#98971a` `#458588` `#d79921` `#8f3f71` | `#f0d6c8` `#e4e8c9` `#d5dfd8` `#f0e0c0` `#e6d5de` |
| `mono` | `#1e1e1e` | `#e9ecef` `#dee2e6` `#ced4da` `#adb5bd` |

Dark mode: `appState.viewBackgroundColor: "#1e1e1e"`, light strokes (`#e9ecef`),
**solid** fills with dark-ish colors (`#364fc7`, `#5f3dc4`) — hachure looks
muddy on dark canvases.

## Generator helpers

```python
import json, random, uuid

elements = []

# STYLE = preset dict, e.g. hand-drawn:
STYLE = dict(roughness=1, fill="hachure", font=1, stroke_width=2)

def _base(t, x, y, w, h, **over):
    e = {"type": t, "id": str(uuid.uuid4()), "x": x, "y": y,
         "width": w, "height": h, "angle": 0,
         "strokeColor": "#1e1e1e", "backgroundColor": "transparent",
         "fillStyle": STYLE["fill"] or "transparent",
         "strokeWidth": STYLE["stroke_width"], "strokeStyle": "solid",
         "roughness": STYLE["roughness"], "opacity": 100,
         "groupIds": [], "frameId": None, "roundness": None,
         "seed": random.randint(1, 2**31),
         "version": 1, "versionNonce": random.randint(1, 2**31),
         "isDeleted": False, "boundElements": None,
         "updated": 1750000000000, "link": None, "locked": False}
    e.update(over)
    return e

def shape(t, x, y, w, h, label, bg=None, font=20, **over):
    s = _base(t, x, y, w, h, **over)
    if bg: s["backgroundColor"] = bg
    s["boundElements"] = []
    elements.append(s)
    if label:
        elements.append({**_base("text", 0, 0, 0, 0),
            "x": x + w/2, "y": y + h/2 - font*0.3,
            "width": len(label)*font*0.62, "height": font*1.25,
            "text": label, "fontSize": font, "fontFamily": STYLE["font"],
            "textAlign": "center", "verticalAlign": "middle",
            "containerId": s["id"], "originalText": label, "lineHeight": 1.25})
        s["boundElements"].append({"id": elements[-1]["id"], "type": "text"})
    return s

def arrow(a, b, label=None):
    ax, ay = a["x"] + a["width"], a["y"] + a["height"]/2
    bx, by = b["x"], b["y"] + b["height"]/2
    ar = {**_base("arrow", ax, ay, bx-ax, by-ay),
          "points": [[0, 0], [bx-ax, by-ay]],
          "lastCommittedPoint": None,
          "startBinding": {"elementId": a["id"], "focus": 0, "gap": 2},
          "endBinding": {"elementId": b["id"], "focus": 0, "gap": 2},
          "startArrowhead": None, "endArrowhead": "arrow", "elbowed": False}
    elements.append(ar)
    for s in (a, b):
        s["boundElements"] = s["boundElements"] or []
        s["boundElements"].append({"id": ar["id"], "type": "arrow"})
    if label:
        elements.append({**_base("text", (ax+bx)/2, (ay+by)/2, 0, 0),
            "width": len(label)*16*0.62, "height": 20, "text": label,
            "fontSize": 16, "fontFamily": STYLE["font"],
            "textAlign": "center", "verticalAlign": "middle",
            "containerId": None, "originalText": label, "lineHeight": 1.25})
    return ar

def free_text(x, y, text, font=20, **over):
    lines = text.split("\n")
    elements.append({**_base("text", x, y, 0, 0, **over),
        "width": max(len(l) for l in lines)*font*0.62,
        "height": len(lines)*font*1.25,
        "text": text, "fontSize": font, "fontFamily": STYLE["font"],
        "textAlign": "left", "verticalAlign": "top",
        "containerId": None, "originalText": text, "lineHeight": 1.25})

# compose the diagram with shape()/arrow()/free_text(), then:
json.dump({"type": "excalidraw", "version": 2, "source": "kroki",
           "elements": elements,
           "appState": {"viewBackgroundColor": "#ffffff", "gridSize": None},
           "files": {}}, open("out.excalidraw", "w"))
```

## Render

kroki.io hosted excalidraw is broken (400/500) — use the local container.
The companion only outputs SVG, so PNG needs resvg as a second step.

```bash
docker run -d --rm --name kroki-ex -p 18004:8004 yuzutech/kroki-excalidraw:latest
curl -s -X POST http://localhost:18004/svg --data-binary @out.excalidraw -o out.svg
npx --yes @resvg/resvg-js-cli out.svg out.png
docker stop kroki-ex
```

## Rules

- Never hand-write the JSON; always generate via script.
- Use `elements.append(...)` inside functions, never `elements += ...` (UnboundLocalError).
- Bound text = separate `text` element with `containerId` + box's `boundElements` entry.
- Arrows: relative `points` + `startBinding`/`endBinding` + arrow refs in both shapes' `boundElements`.
- Text width ≈ `chars × fontSize × 0.62` — long labels overflow; shrink font or widen box.
- Always view the rendered PNG and fix overlaps before presenting. Iterate.

### Verified vs broken (probe-tested against the kroki container)

Works: rectangle/ellipse/diamond, straight arrows + bindings, bound text,
frames with names, dashed/dotted strokes, opacity, custom arrowheads
(`triangle`, `bar`, `circle`), dark canvas, multi-line text, any hex colors.

Broken — do not use:
- Elbow arrows (`elbowed: true`) render as straight diagonals.
- Curved arrows need 3+ points; 2-point arrows render straight. Stick to straight.
- fontFamily 2/3 render as a clean sans fallback (not true Helvetica/Cascadia) — fine for `minimal`, don't expect exact fonts.
