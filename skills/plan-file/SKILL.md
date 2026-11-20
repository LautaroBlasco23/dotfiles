---
name: plan-file
description: >-
  Write the implementation plan to a Markdown file under /tmp/agent-plans/
  that the user can inspect and edit in Neovim. Also read manual edits back,
  answer `# Question:` entries, and update or reopen the plan. TRIGGER when
  the user explicitly mentions /plan-file or asks to save the plan to a file
  (e.g. "design X, use /plan-file"). DO NOT auto-invoke for planning requests
  that don't mention the skill.
metadata:
  opencode/autoinvoke: false
---

# Plan File

## Purpose

Materialize the implementation plan as a Markdown file the user can inspect
and edit directly in Neovim. Invoked explicitly by the user; never fires on
its own. Plans are feedback artifacts: the point is a readable, editable
file, not a persistent planning workflow.

## Invoking

- The user may invoke this skill alongside a planning request (e.g. "design
  the refactor to improve the efficiency of this block, use /plan-file").
  In that case, produce the plan in the conversation first, then write it to
  the file. The skill materializes a plan; it does not replace planning.
- If no plan exists in the conversation, draft one from the current task
  context before creating the file. Never write an empty or placeholder
  file.

## Creating a plan file

1. Create a directory under `/tmp/agent-plans/` named after the plan's
   content, kebab-case (`refactor-auth-loop`, not `plan1`). If the name is
   taken by another agent's plan, pick a different name.
2. Write the plan to `plan.md` inside that directory.
3. End the invocation by telling the user the absolute path and giving a
   ready-to-run open command:

       cd /tmp/agent-plans/<name> && nvim plan.md

Never launch a terminal or Neovim yourself; the user opens the file.

## Updating an existing plan

When the user says the plan was edited ("I made some updates, read those
changes and update the file accordingly") or asks to reopen it:

1. Read the existing file before touching it. Never overwrite manual edits
   without reading them first.
2. Preserve existing content unless changes are explicitly requested.
3. Write the updated content back to the same file in the same directory.
4. Do not create a new directory for an update.
5. Print the absolute path and open command again.

## Questions

If the plan file contains lines like:

    # Question: Why are we modifying this module?

the agent must:

1. Find every `# Question:` occurrence and understand it in the context of
   the plan and the codebase.
2. Answer each question directly in the conversation.
3. Leave the questions untouched in the file.
4. Offer to append each answer into the file below its question as an
   `# Answer:` line, and only do so if the user accepts.
5. Wait for the user's instructions before modifying the plan further.

## Rules

- User-trigger only. Never invoke automatically.
- All plans live under `/tmp/agent-plans/` — a shared location also used by
  other AI agents. Never delete or write into a directory you didn't create
  in this conversation.
- Name directories by content, kebab-case.
- Use absolute paths when referencing the plan file.
- Always end an invocation by printing the path and the open command.
- No automatic terminal or editor launching.
