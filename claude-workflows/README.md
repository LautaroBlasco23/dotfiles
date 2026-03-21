# Claude Workflows

This directory contains alternative development workflows for Claude.

## Available Workflows

### dev-pipeline

Structured 4-phase pipeline focused on iterative development.

**Pipeline**: `plan → research → implement → review`

**Agents**:
- planner (opus) - Creates implementation plan
- researcher (haiku) - Researches codebase patterns
- implementer (sonnet) - Writes code
- reviewer (sonnet) - Reviews implementation

**Key traits**:
- User confirmations between each phase
- Researches existing codebase before implementing
- Flexible and iterative

---

### spec-driven

Formal 5-phase pipeline with enforced documentation and architecture gates.

**Pipeline**: `spec → plan → implement → architecture-guardian → review`

**Agents**:
- spec-writer (opus) - Writes formal spec
- planner (opus) - Creates ordered task list
- implementer (sonnet) - Writes code
- architecture-guardian (sonnet) - Scans for violations
- validator (sonnet) - Validates against spec

**Key traits**:
- Requires formal spec before implementation
- Has **gates** — stops if violations found
- Architecture/coding-standards enforcement
- More heavyweight, policy-driven

---

## Comparison

| Aspect             | dev-pipeline          | spec-driven               |
|--------------------|-----------------------|---------------------------|
| Phases             | 4                     | 5                         |
| Upfront spec       | No                    | Yes                       |
| Architecture gates | No                    | Yes                       |
| Confirmations      | Yes                   | Optional                  |
| Best for           | Iterative/exploratory | Policy/compliance-heavy   |

## Choosing a Workflow

- **dev-pipeline**: Use when you want flexibility and want to discover patterns as you build.
- **spec-driven**: Use when you need formal documentation, architecture enforcement, or team alignment.
