---
name: dev-pipeline
slug: dev-pipeline
description: >-
  Orchestrates the planner -> researcher -> implementer -> reviewer pipeline.
  TRIGGER when: user says "run dev-pipeline", "develop this", "full pipeline",
  or asks to run the structured development workflow.
---

# Dev Pipeline

Orchestrate the 4-phase development pipeline using custom agents.

## Pipeline phases

Run these phases **sequentially** -- each depends on the previous:

1. **Plan** -- invoke the `planner` agent with the user's request
   - After completion, read `.docs/plan.md` and present a summary to the user
   - Wait for user confirmation before proceeding

2. **Research** -- invoke the `researcher` agent
   - Prompt: "Read .docs/plan.md and research the codebase for relevant patterns"
   - After completion, read `.docs/research.md` and present a summary
   - Wait for user confirmation before proceeding

3. **Implement** -- invoke the `implementer` agent
   - Prompt: "Read .docs/plan.md and .docs/research.md, then implement the plan"
   - After completion, read `.docs/implementation-log.md` and present a summary
   - Wait for user confirmation before proceeding

4. **Review** -- invoke the `reviewer` agent
   - Prompt: "Read all .docs/ artifacts and git diff, then review the implementation"
   - After completion, read `.docs/review.md` and present the full review

## Skip confirmations

If the user says "full pipeline", "run all", or "no confirmations", skip the confirmation steps between phases and run all 4 sequentially.

## How to invoke agents

Use the Agent tool with the appropriate agent:

```
Agent(subagent_type="planner", prompt="<user request>")
Agent(subagent_type="researcher", prompt="Read .docs/plan.md and research the codebase")
Agent(subagent_type="implementer", prompt="Read .docs/plan.md and .docs/research.md, then implement")
Agent(subagent_type="reviewer", prompt="Read all .docs/ artifacts and git diff, then review")
```

## Prerequisites

Before starting the pipeline, verify:
- `.docs/` is in the project's `.gitignore` (warn if not)
- The user's request is clear enough to plan against

## After the pipeline

Present the review summary and ask the user if they want to:
- Fix any issues found by the reviewer
- Commit the changes
- Run the pipeline again with adjustments
