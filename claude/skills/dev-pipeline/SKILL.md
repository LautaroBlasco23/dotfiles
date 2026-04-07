---
name: dev-pipeline
slug: dev-pipeline
description: >-
  Orchestrates the researcher -> planner -> implementer(s) -> preflighter pipeline.
  TRIGGER when: user explicitly invokes with "/" (e.g., /dev-pipeline).
  This skill builds on top of `agent-injection` -- all agent prompts must follow
  those rules. Do NOT auto-trigger based on conversation context.
---

# Dev Pipeline

Orchestrate the development pipeline using custom agents. See `agent-injection` skill for mandatory rules on agent prompting.

## Pipeline phases

Run these phases **sequentially** -- each depends on the previous:

1. **Research** -- invoke the `researcher` agent with the user's request
   - Prompt: "Research the codebase for patterns relevant to: <user request>"
   - After completion, read `.docs/research.md` and present a summary to the user
   - Wait for user confirmation before proceeding

2. **Plan** -- invoke the `planner` agent
   - Prompt: "Read .docs/research.md and produce an implementation plan for: <user request>"
   - After completion, read `.docs/plan.md` and present a summary to the user
   - Pay attention to the **Execution Strategy** section -- it defines how many implementer streams to use
   - Wait for user confirmation before proceeding

3. **Implement** -- invoke implementer agent(s) based on the plan's Execution Strategy
   - Read `.docs/plan.md` and parse the `## Execution Strategy` section
   - If **1 stream**: invoke a single `implementer` agent
     - Prompt: "Read .docs/plan.md and .docs/research.md, then implement the plan"
   - If **multiple streams**: invoke implementer agents **in parallel** (one per stream)
     - Each agent gets a targeted prompt: "Read .docs/research.md for codebase patterns. Your task is to implement **Stream N: <name>** from .docs/plan.md. Only implement the steps listed in your stream: steps <X, Y, Z>. Files you own: <list>. Context: <context needed from plan>. Do NOT touch files outside your stream."
   - After all implementers complete, read their `.docs/implementation-log.md` outputs and present a summary
   - Wait for user confirmation before proceeding

4. **Validate** (conditional) -- invoke the `preflight-validator` agent if needed
   - Check the project's `CLAUDE.md` for a `## Preflight` section
   - If the section exists and Status is "ready", skip this step
   - If the section is missing or Status is "not ready", invoke the validator:
     - Prompt: "Validate the project environment for preflight readiness. Inspect toolchain, tools, and dependencies."
   - After completion, read the updated `## Preflight` section and present the results
   - If Status is "not ready", warn the user about blockers before proceeding

5. **Preflight** -- invoke the `preflighter` agent
   - Prompt: "Run build, check, and tests to verify the implementation. Read .docs/plan.md for testing strategy context."
   - If all checks pass, the preflighter reports success directly (no file written)
   - If any check fails, read `.docs/preflight.md` and present the failure report

## Skip confirmations

If the user says "full pipeline", "run all", or "no confirmations", skip the confirmation steps between phases and run all 5 sequentially.

## How to invoke agents

All prompts must follow `agent-injection` rules. Examples:

```
# Researcher - provide context about the request
Agent(subagent_type="researcher", prompt="
## Task
Research the codebase for patterns relevant to: <user request>

## Context
Project: <name>. Stack: <tech stack>. Structure: <brief folder layout>.
User request: <detailed request>

## Scope
- In scope: <relevant subsystems/files>
- Out of scope: <ignore these areas>

## Steps
1. Search for patterns in <specific locations>
2. Identify conventions (naming, error handling, etc.)
3. Summarize findings

## Output
Write to .docs/research.md. Format: executive summary + detailed findings + conventions identified.

## Token Budget
Quick: 5 bullet points + relevant code snippets (max 200 lines).
")

# Planner - must read research output first
Agent(subagent_type="planner", prompt="
## Task
Produce an implementation plan for: <user request>

## Context
Read .docs/research.md for codebase patterns.
User request: <detailed request>

## Scope
- In scope: <features/files to modify>
- Out of scope: <do not touch>

## Steps
1. Analyze requirements vs existing patterns
2. Design solution
3. Define execution streams (if parallel needed)
4. Define testing strategy

## Output
Write to .docs/plan.md with: Overview, Detailed Steps, ## Execution Strategy (with stream definitions), Testing Strategy.

## Token Budget
Medium: thorough analysis, up to 500 lines of plan content.
")

# Implementer - single stream
Agent(subagent_type="implementer", prompt="
## Task
Implement the plan.

## Context
Read .docs/plan.md and .docs/research.md.
Project conventions from research: <summary of key patterns>

## Scope
- Owns: <files from plan>
- Do NOT touch: <explicit exclusions>

## Steps
<numbered steps from plan - be specific>

## Output
Write to .docs/implementation-log.md. Log each step completed and files modified.

## Token Budget
Deep: implement fully, all code changes needed.
")

# Implementer - parallel streams (launch in single message)
Agent(subagent_type="implementer", prompt="
## Task
Implement **Stream N: <name>**

## Context
Read .docs/research.md for codebase patterns.
Shared context: <summary all agents need>
This agent ONLY implements Stream N. Other streams handled separately.

## Scope
- Owns: <files for this stream only>
- Do NOT touch: <explicitly list other streams' files>

## Steps
<numbered steps from plan for this stream only - be specific>

## Output
Write to .docs/implementation-log.md. Log each step completed and files modified.

## Token Budget
Deep: implement fully for this stream only.
")

# Validator
Agent(subagent_type="preflight-validator", prompt="
## Task
Validate project environment for preflight readiness.

## Context
Project: <name>. Toolchain: <list tools available>.

## Scope
- Check: toolchain, tools, dependencies
- Out of scope: code quality, linting

## Steps
1. Inspect CLAUDE.md for existing preflight config
2. Check required tools are installed
3. Verify dependencies available
4. Update/preflight section in CLAUDE.md

## Output
Write to .docs/preflight-validation.md. Update ## Preflight section in project's CLAUDE.md.

## Token Budget
Quick: surface-level check only.
")

# Preflighter
Agent(subagent_type="preflighter", prompt="
## Task
Run build, check, and tests to verify implementation.

## Context
Read .docs/plan.md for testing strategy.
Read ## Preflight section in project's CLAUDE.md for available tools.

## Scope
- Run: build, typecheck, lint, tests
- Out of scope: code changes

## Steps
1. Run build command
2. Run typecheck
3. Run lint
4. Run tests

## Output
If all pass: report success directly (no file).
If any fail: write to .docs/preflight.md with failure details.

## Token Budget
Quick: run commands, report results.
")
```

## Prerequisites

Before starting the pipeline, verify:
- `.docs/` is in the project's `.gitignore` (warn if not)
- The user's request is clear enough to plan against

## After the pipeline

If the preflighter reported success (no `.docs/preflight.md` written), confirm all checks passed and ask the user if they want to commit.

If the preflighter reported failures (`.docs/preflight.md` exists), present the failure report and ask the user if they want to:
- Fix the issues found by the preflighter
- Commit the changes as-is
- Run the pipeline again with adjustments
