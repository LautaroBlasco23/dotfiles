---
name: example
slug: example
description: >-
  Include simple, effective examples when explaining complex topics, comparing
  options, or teaching a new concept. TRIGGER when the user asks "why", "explain",
  "what is", "how does X work", compares options (A vs B), asks for an
  analogy/metaphor/diagram to understand something, or when the explanation
  would otherwise be abstract. DO NOT TRIGGER for code generation tasks, simple
  factual questions, commands, or when the user asks for brevity.
---

# Examples in Explanations

When a topic is complex, abstract, or new to the user, don't just explain it —
show it. Use the kind of examples good technical books use: a metaphor for
intuition, a diagram for structure, a concrete scenario for behavior, real
code for precision.

## The ladder of abstraction

Climb only as high as the topic and the user need. One or two well-chosen
examples beat a catalog of them.

1. **Metaphor / analogy** ("Imagine a library where...") — for intuition on a
   genuinely new concept. Drop it once precision matters.
2. **Diagram or sketch** — for structure, relationships, and data flow.
   For polished diagrams, use the ascii-diagram skill; otherwise a small
   inline ASCII/text sketch is fine.
3. **Concrete scenario** ("Here's how a login request would flow through
   this...") — for behavior over time, step by step, in plain language.
4. **Technical example** — actual code, commands, config, or file paths.
   Prefer the user's real codebase over synthetic code whenever the repository
   can provide it.

## Comparisons (A vs B)

When explaining why option A is better than option B, don't describe the
difference — show the same scenario through both lenses:

- "With clean architecture, adding a new payment provider touches only these
  files... With the alternative, it touches these..."
- The contrast itself is the example. Keep both sides short and symmetric.

## Rules

- Choose examples for the reader, not for completeness. What does this
  particular user not yet see?
- Vary the point of view when helpful: the same example from the developer's
  view, the system's view, or the user's view.
- Every example must be correct and consistent with the explanation. A wrong
  or sloppy example is worse than none.
- Keep each example to one idea. If an example needs its own explanation,
  simplify it.
- Stop at the lowest abstraction level that makes the point. A user who
  understands metaphors doesn't need code; a user deep in code doesn't need
  a metaphor.
- If the user asks for brevity, at most one short example.

## Principles

- One example that lands beats three that don't.
- Examples illuminate; they never pad.
- Prefer showing over telling whenever showing is cheaper than describing.
- With progressive-response, examples belong in the detailed body — summaries
  stay example-free.
