---
name: ai-comments
slug: ai-comments
description: >-
  Process @ai-comment, @ai-todo and @ai-question directives in a file.
  TRIGGER when: user invokes /ai-comments or asks to resolve AI directives
  in a file (e.g. "/ai-comments @thisfile.md").
  DO NOT TRIGGER for general coding tasks.
---

# AI Comments

The user leaves inline directives in code using three marker types. Your job
is to resolve each one, then clean up all markers.

Marker line format (any comment prefix: `//`, `#`, `--`):

```
// @ai-comment <instruction>
# @ai-todo <instruction>
-- @ai-question <instruction>
```

## Workflow

1. **Read the target file(s)** given as the invocation argument.
   If no argument, ask which file, or use the file the user referenced in
   their message.

2. **Scan for markers** using the pattern:
   `^\s*(//|#|--)\s*@ai-(comment|todo|question)\b`

3. **Treat each marker as an independent THREAD.** For each thread collect:
   - the marker type
   - the full instruction text (may span following lines until the next
     marker)
   - its location (file + line)

   Threads are independent: process them one at a time and report on each
   separately, like separate conversations. Example:

   ```
   question "explain this variable": <answer in chat>
   todo "extract to utils": <what was done, files touched>
   todo "refactor loop": <what was done, files touched>
   ```

4. **Resolve each thread by type:**

   - `@ai-comment` — the user wants the code explained in place because it
     is hard to read. Write a proper explanatory comment into the code at
     that location. The marker line itself is temporary scaffolding: the
     explanation stays, the marker goes.

   - `@ai-todo` — the user describes a change to implement: a refactor,
     extracting a function to a new file (e.g. `utils/x.go`) and importing
     it here, etc. Implement the smallest change that satisfies the
     instruction. Do not expand scope to "the rest of the files" — the user
     said they will handle those.

   - `@ai-question` — the user wants an answer in chat only, without
     leaving a comment behind (e.g. "why is this variable created?",
     "does this function cover this use case?"). Answer in the chat.
     Make ZERO code changes for questions.

## Rules

- Never delete non-marker comments.
- If a `@ai-todo` is ambiguous, ask the user before implementing.
- **Cleanup only after ALL threads are resolved**: remove every remaining
  marker line matching the scan pattern. Then verify with grep that zero
  markers remain in the touched files. If any thread was skipped, do NOT
  run cleanup.
- Final report in chat: one entry per thread — what was done or answered,
  and which files were touched.
