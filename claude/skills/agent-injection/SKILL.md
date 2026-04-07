---
name: agent-injection
slug: agent-injection
description: >-
  TRIGGER when: user wants to use an agent to solve a task, or the main conversation agent
  spawns a subagent. This skill is MANDATORY for every agent invocation.
---

# Agent Injection

Rules for spawning agents. Follow these every time an agent is invoked.

## Mandatory Rules

### 1. Context Injection (Non-Negotiable)

Every agent prompt MUST include:

- **Relevant file contents**: Pass exact code the agent needs to work with, not just paths
- **Codebase patterns**: Include examples of existing conventions (naming, structure, imports)
- **Project context**: Structure, architecture decisions, tech stack
- **Previous outputs**: If chaining agents, include prior agent artifacts (e.g., `.docs/research.md`)

**Bad**: "Fix the bug in auth.go"
**Good**: "Fix the bug in auth.go. The issue is on line 42 - null pointer. See current implementation:\n```go\n// auth.go:40-50\n<file contents>\n```\nOur auth pattern is: <brief pattern>. Do NOT change the user repository."

### 2. Specificity Over Generality

Agent prompts must define:
- **Exact scope**: What files/subsystems are in scope
- **Explicit exclusions**: What NOT to touch
- **Concrete steps**: Numbered list of specific actions when possible

**Bad**: "Research the codebase for patterns"
**Good**: "Research the codebase for auth patterns. Focus on: auth.go, middleware/. Look for: JWT validation, session handling. Ignore: legacy/ folder. Return findings in 5 bullet points max."

### 3. Task Partitioning (Multiple Agents)

When spawning parallel agents:
- Define **non-overlapping file ownership** upfront
- State explicit boundaries: "Agent A owns files X, Y. Agent B owns files W, Z"
- Include a **shared context section** all agents must read
- Prevent duplicate work by stating what each agent does NOT do

### 4. Token Budget

Set depth expectations based on task:
- **Quick**: "2-3 files max", "return 5 bullet points"
- **Medium**: "analyze the module thoroughly", "up to 500 lines of code"
- **Deep**: "full analysis", "comprehensive review"

Specify max context length if the agent should limit scope.

### 5. Output Convention

Tell the agent where to write results:
- File path (e.g., `.docs/research.md`)
- Format expectations (bullet points, sections, etc.)
- Whether to present summary to user before or after writing

## Prompt Template

```
## Task
<specific task description>

## Context
<relevant code, patterns, project info>

## Scope
- In scope: <files/features>
- Out of scope: <files/features>

## Steps
1. <specific step>
2. <specific step>

## Output
<where to write, format>

## Token Budget
<quick/medium/deep or specific limits>
```

## Enforcement

This skill applies to ALL agent invocations regardless of:
- Agent type (researcher, planner, implementer, etc.)
- How the agent is invoked (Task tool, slash command, direct spawn)
- Whether spawning one or multiple agents

Dev-pipeline and other orchestration skills MUST reference this skill rather than duplicating its rules.
