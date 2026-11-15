---
name: lists
description: >-
  Keep every list in responses as a simple flat bullet list: one item per line,
  no nesting, no numbering, no tables. Applies whenever presenting items to the
  user (PRs to review, worktrees, files, todos, and so on).
metadata:
  opencode/autoinvoke: false
---

# Lists

Whenever a response contains a list of items, present it as a **simple flat
bullet list**. One line per item, `-` prefix, nothing else.

## Rules

1. **Bullets only.** Use `-` for every list, regardless of content.
2. **One level.** Never nest lists. If items have sub-items, keep them as
   separate top-level bullets or drop them.
3. **No numbering.** Numbers imply order; plain items don't need it.
4. **No extra prose per item.** One line: the item itself (name, URL, path).
   No explanations, no trailing commentary.
5. **No tables.** A list of items is never a table, even when items share
   attributes.
6. **A header is enough.** A short bold label before the list (`**PRs to
   review:**`) replaces any introduction or explanation around it.

## Format

    **<label>:**
    - item
    - item
    - item

## Examples

**PRs to review:**

- https://github.com/org/repo/pull/101
- https://github.com/org/repo/pull/102
- https://github.com/org/repo/pull/103

**Worktrees:**

- feature-1
- feature-2
- feature-3

**Files changed:**

- src/index.ts
- src/utils.ts
