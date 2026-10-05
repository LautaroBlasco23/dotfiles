# Progressive Disclosure for Long Responses

When a response is substantial (for example: a multi-phase plan, investigation,
review, or analysis), preserve the complete technical response but add an
orientation layer before it.

## Structure

### Summary

In 1–2 short paragraphs:

- State the main conclusion or diagnosis.
- State the proposed approach.
- Mention important constraints or risks only when they materially affect the plan.
- Do not introduce information that is absent from the detailed response.

### Plan at a glance

Provide 3–7 concise bullets that act as a semantic index to the detailed response.

Each bullet should:

- identify a meaningful area of work;
- state the intended change or finding, not merely repeat a section heading;
- optionally include scope when useful (e.g. "15 occurrences", "9 call sites").

Example:

- **Tokens:** fix `primaryForeground` at the shared source of truth, register it
  in Tailwind, then update 9 mobile call sites.
- **Spacing:** replace unsupported `space-y-*` utilities with `gap-*`; verify
  the two ScrollView cases separately.
- **Theme colors:** replace 30+ hardcoded colors with token-driven values.

### Detailed response

Keep the complete analysis, evidence, implementation details, file references,
verification steps, caveats, and risks. Do not remove useful technical detail
merely because it was summarized above.

## Principles

- Optimize for progressive disclosure, not brevity.
- A reader should understand the conclusion and proposed work without reading
  the detailed section.
- A reader who needs implementation details should lose nothing by continuing.
- Do not duplicate large amounts of detail between the summary and body.
- Do not add this structure to responses that are already short or simple.
- Prefer concrete statements over meta-language such as "the agent found..."
  or "this response will explain...".
