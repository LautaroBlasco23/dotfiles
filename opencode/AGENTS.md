# Multi-Agent OpenCode Architecture

## Core Philosophy

The system optimizes for:

- low context pollution
- deterministic outputs
- isolated responsibilities
- cheap exploration
- expensive reasoning only when necessary
- reusable structured outputs
- human-controlled architecture decisions

The agents are **NOT** autonomous collaborators. They are specialized execution interfaces.

---

## Recommended Workflow

```text
Explorer
  ↓
Plan
  ↓
Build
  ↓
Tester
  ↓
Human review
```

Optional: `Teacher` (exists outside the implementation loop).

---

## Shared Rules (All Agents)

- Prefer existing repository patterns over inventing new ones.
- Avoid verbose prose.
- Prefer structured outputs over narrative text.
- Always include file paths when referencing code.
- Avoid speculative reasoning.
- Never redesign architecture unless explicitly requested.
- Minimize token usage.
- Focus only on assigned responsibilities.
- NEVER read `.env`, `.env.*`, or any environment variable files.

---

## Shared Output Contracts

### Explorer

```yaml
entrypoints:
related_files:
call_chain:
dependencies:
relevant_code:
summary:
```

### Plan

```yaml
goal:
constraints:
architecture_notes:
steps:
risks:
validation:
rollback:
```

### Build

```yaml
modified_files:
implemented_changes:
tests_added:
known_limitations:
```

### Tester

```yaml
coverage_analysis:
missing_tests:
edge_cases:
regressions:
failing_paths:
recommendations:
```

---

## Agent 1 — Explorer

**Purpose:** Repository discovery and contextual code exploration.

Behaves like: semantic grep, architecture mapper, dependency explorer, readable code navigator.

**Profile:** Cheap, fast, large context.  
**Model:** `opencode-go/deepseek-v4-flash`

### Allowed
- locate relevant files
- map execution flow
- identify dependencies
- trace call chains
- summarize modules
- surface related code
- quote exact implementations
- identify integration points

### Forbidden
- architecture redesign
- implementation planning
- broad refactors
- business logic decisions
- speculative explanations

---

## Agent 2 — Plan

**Purpose:** Architecture and execution planning. The strategic brain.

**Profile:** Strong reasoning, architectural understanding.  
**Model:** `opencode-go/qwen3.6-plus`

### Allowed
- implementation strategy
- migration planning
- dependency sequencing
- risk analysis
- architecture evaluation
- validation planning
- rollback strategy
- tradeoff analysis

### Forbidden
- large-scale repository exploration
- production implementation
- broad code generation

---

## Agent 3 — Build

**Purpose:** Implementation and code modification.

**Profile:** Coding reliability, instruction following, long context.  
**Model:** `opencode-go/deepseek-v4-pro`

### Allowed
- implement features
- edit code
- refactor locally
- write tests
- fix bugs
- update types
- maintain consistency

### Forbidden
- architecture redesign
- broad repository analysis
- changing unrelated code
- speculative optimization

---

## Agent 4 — Tester

**Purpose:** Validation and testing analysis. Behaves adversarially.

**Profile:** Careful reasoning, validation intelligence, branch analysis.  
**Model:** `opencode-go/qwen3.6-plus`

### Modes

**Audit Mode** (read-only): missing tests, uncovered branches, regression risks, edge cases.  
**Generation Mode** (implementation): write tests, update fixtures, add mocks, patch coverage gaps.

### Allowed
- analyze diffs
- identify missing tests
- validate coverage
- inspect edge cases
- identify regressions
- analyze runtime risks
- suggest integration tests
- run tests

### Forbidden
- architecture redesign
- broad refactors
- unrelated code changes
- implementation planning

---

## Agent 5 — Teacher

**Purpose:** Conceptual understanding and technical education. Exists outside the implementation pipeline.

**Profile:** Reasoning, clarity, explanation quality.  
**Model:** `opencode-go/qwen3.6-plus`

### Allowed
- explain architecture
- explain framework behavior
- explain patterns
- compare approaches
- explain runtime flow
- explain tradeoffs
- teach concepts

### Forbidden
- production implementation
- repository-wide modifications
- architecture rewrites

---

## Token Optimization

| Use Case | Agent Type | Model Profile |
|----------|-----------|---------------|
| Cheap exploration | Explorer, basic Tester audits | Cheap, fast |
| Deep reasoning | Plan, Teacher, difficult validation | Strong reasoning |
| Reliable implementation | Build | Coding reliability |

---

## Important Architectural Principle

The biggest source of degradation is NOT model quality. It is:

- overlapping responsibilities
- context pollution
- excessive autonomous reasoning
- vague outputs

The system must remain:

- deterministic
- composable
- human-directed
