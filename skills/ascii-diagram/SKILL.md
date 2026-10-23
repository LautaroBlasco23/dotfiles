---
name: ascii-diagram
description: Create, improve, and validate text-based diagrams for technical documentation. Use when documenting data models, architecture, request flows, sequences, hierarchies, state transitions, or component relationships. Prefer ASCII or Unicode diagrams when requested or appropriate, and recommend Mermaid when it offers a materially better result.
---

# ASCII Diagram Skill

## Purpose

Produce clear, semantically accurate, maintainable diagrams for technical documentation. Optimize for comprehension, not visual decoration.

## Workflow

1. **Understand the source**
   - Extract components, entities, fields, relationships, constraints, and flows.
   - Preserve names, types, optionality, cardinality, direction, and business rules.
   - Identify ambiguities. Ask a question only when the missing information materially affects correctness.
   - Never invent components, relationships, or constraints.

2. **Choose the representation**
   - Entity and data models: entity boxes, fields, keys, and labeled relationships.
   - Architecture diagrams: components, infrastructure boundaries, dependencies, and protocols.
   - Request flows: directional arrows and explicit entry/exit paths.
   - Sequence diagrams: participants and ordered interactions.
   - Hierarchies: indented trees.
   - State machines: states and labeled transitions.
   - Mixed concerns: split into multiple diagrams when doing so improves clarity.
   - One concern per diagram. When a topic mixes structure (components and boundaries), data (fields and keys), and behavior (flows and sequencing), produce a separate diagram for each concern instead of one overloaded diagram.
   - When splitting into detail diagrams, lead with a small overview diagram showing only the main components and their relationships, then present each detail diagram. Give every diagram a short title so prose can reference it.

3. **Design the layout**
   - Prefer the simplest layout that communicates the intended information.
   - Use left-to-right flows for pipelines and top-to-bottom flows for layered systems when appropriate.
   - Group related components and label meaningful boundaries.
   - Keep connectors close to their endpoints.
   - Minimize crossing lines, excessive whitespace, and unnecessary connector bends.
   - Keep diagrams under ~80 characters wide so they render in common Markdown viewers and diffs without horizontal scrolling.
   - Split dense diagrams instead of shrinking labels or omitting information.

4. **Apply consistent notation**
   - Use consistent box borders, indentation, arrows, and spacing.
   - Label relationships and protocols where their meaning is not obvious.
   - Distinguish containment from dependency and hierarchy from association.
   - Represent optionality, cardinality, and direction explicitly when relevant.
   - Use ASCII-only characters when portability is required; otherwise, Unicode box-drawing characters are acceptable.
   - Do not mix ASCII and Unicode drawing conventions unnecessarily.

5. **Preserve technical semantics**
   - Keep identifiers, field names, types, and technology names unchanged unless asked to edit them.
   - Distinguish primary keys, foreign keys, composite keys, and nullable fields.
   - Distinguish synchronous requests from asynchronous events.
   - Represent alternate request paths separately when their routing differs.
   - Separate structural information from business rules when their visual hierarchy differs.
   - Do not imply ordering, ownership, or cardinality through layout alone.

6. **Choose the right output format**
   - Follow an explicitly requested format.
   - Use fenced code blocks for ASCII and Unicode diagrams.
   - Consider Mermaid for flowcharts, sequence diagrams, entity relationship diagrams, and diagrams that benefit from automatic layout.
   - Recommend another format only when it materially improves readability or maintainability.
   - Do not replace a requested ASCII diagram with Mermaid without explaining the trade-off.

7. **Validate before responding**
   - Check that all relevant source components and relationships are represented.
   - Verify arrow directions, labels, boundaries, and relationship semantics.
   - Check box alignment, indentation, connector continuity, and character consistency.
   - Ensure the diagram remains understandable in a monospaced font.
   - Look for ambiguous connectors and unintended hierarchy.
   - Compare the final diagram against the source to avoid omissions or invented details.

## Output Contract

- Return the diagram in a fenced code block.
- Include a short title when useful.
- When delivering multiple diagrams, lead with the overview diagram, then the detail diagrams, each with its own title.
- Keep explanations outside the diagram.
- Mention assumptions only when they affect interpretation.
- If the source contains unresolved ambiguity, state it concisely.
- Prefer delivering the improved diagram directly over explaining general diagramming principles.
- When revising an existing diagram, preserve its intended meaning and improve its structure without unnecessary changes to terminology.

## Style Example: Request Flow

```text
Browser
   |
   v
Nginx (static frontend + API proxy)
   |
   +-- /api/* --> Backend API
                     |
                     +--> PostgreSQL
                     |
                     +--> MongoDB

Mobile App / Extension
   |
   +-- direct HTTP --> Backend API
```

This is an illustrative layout, not a substitute for the actual architecture. Preserve the source's real routing, protocols, and service boundaries.

## Style Example: Data Model

```text
User
+---------------------------+
| id (PK)                   |
| firstName                 |
| lastName                  |
| profilePicUrl?            |
| profilePrivacyStatus      |
+---------------------------+
          |
          | 1
          |
          | 0..*
+---------------------------+
| Follow                    |
|---------------------------|
| followerId (PK, FK)       |
| followeeId (PK, FK)       |
| status                    |
| acceptedAt?               |
+---------------------------+
          |
          | followeeId
          v
         User
```

This is an illustrative layout. Verify the actual cardinality and foreign-key semantics before using it.

## General Principles

- Accuracy before aesthetics.
- Clarity before compactness.
- Consistency before novelty.
- Explicit semantics before implicit visual conventions.
- Preserve source information; do not fill gaps with assumptions.
- Prefer the smallest diagram that communicates the complete intended model.
