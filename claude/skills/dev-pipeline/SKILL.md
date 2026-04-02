---
name: dev-pipeline
slug: dev-pipeline
description: >-
  Orchestrates the researcher -> planner -> implementer(s) -> preflighter pipeline.
  TRIGGER when: user says "run dev-pipeline", "develop this", "full pipeline",
  or asks to run the structured development workflow.
---

# Dev Pipeline

Orchestrate the development pipeline using custom agents.

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

```
Agent(subagent_type="researcher", prompt="Research the codebase for patterns relevant to: <user request>")
Agent(subagent_type="planner", prompt="Read .docs/research.md and produce an implementation plan for: <user request>")

# Single implementer:
Agent(subagent_type="implementer", prompt="Read .docs/plan.md and .docs/research.md, then implement the plan")

# Parallel implementers (launch in a single message):
Agent(subagent_type="implementer", prompt="...stream 1 prompt...")
Agent(subagent_type="implementer", prompt="...stream 2 prompt...")

# Validator (only if no ## Preflight section in CLAUDE.md):
Agent(subagent_type="preflight-validator", prompt="Validate the project environment for preflight readiness")

Agent(subagent_type="preflighter", prompt="Run build, check, and tests to verify the implementation")
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
