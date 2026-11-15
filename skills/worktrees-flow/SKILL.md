---
name: worktrees-flow
description: Work with git worktrees in the container layout — one folder per repository holding the shared .git, a main/ worktree, and all linked worktrees as siblings. TRIGGER when the user says "create a worktree", "work inside a worktree", "use worktrees for this", "in the worktree", mentions the worktree container, or when a task needs its own branch and an isolated checkout. Covers container setup, migrating a plain repo into the layout, adding/removing worktrees, naming, and cleanup. NOT for explaining git worktree internals in general discussion.
---

# Worktrees Flow

## Concept

Every repository lives in a **container**: a folder named after the repo that
holds the one shared `.git` and every worktree as siblings. The container itself
is not a worktree and contains nothing else.

```
life-tracker/                            ← container (not a worktree itself)
├── .git/                                ← single object database for all branches
├── main/                                ← main worktree (core.worktree = ../main)
├── docs-remove-stale-plans-and-assets/  ← linked worktree (branch of same name)
└── life-tracker-notes/                  ← linked worktree
```

**Invariants**

- `main/` is the only worktree on the default branch, regardless of the branch's
  actual name (`main`, `master`, …). All other work happens in linked worktrees.
- One worktree per active branch. Worktree folder name = branch name:
  kebab-case, descriptive of the task (`docs-remove-stale-plans-and-assets`,
  not `wt2`).
- Worktrees are always siblings of `main/`: never nested, never outside the
  container.
- Uncommitted changes stay in exactly one worktree; never duplicate work across
  worktrees.

## Decision procedure

1. **Classify the repo** (see Detection below): container layout, plain repo, or
   already inside a linked worktree of a container.
2. **Container layout** → work inside it. If a worktree matching the task
   already exists (`git worktree list`), reuse it; otherwise create one.
3. **Plain repo** → propose the one-time migration (see Migrating). Wait for
   explicit approval before touching anything.
4. **Inside a linked worktree** → stay there unless the task belongs on another
   branch.

## Detection

The `core.worktree` marker distinguishes a container from a plain repo:

```bash
COMMON="$(git rev-parse --git-common-dir)"        # <container>/.git when containerized
git config --file="$COMMON/config" core.worktree  # "../main" → container; empty → plain repo
```

## Creating a worktree (the common case)

From `main/` (or any worktree of the container):

```bash
cd <container>/main
git worktree add ../<name> -b <name>    # new branch + worktree for this task
# for an existing branch: git worktree add ../<name> <name>
```

Do all work inside `<container>/<name>`.

## Creating the container

**New repo** — containers for new repos live under `~/projects/<repo-name>/`:

```bash
mkdir -p ~/projects/<repo> && cd ~/projects/<repo>
git init main
mv main/.git .git
git config --file=.git/config core.worktree ../main
```

**Migrating an existing plain repo** — the container keeps the repo's current
path; uncommitted changes are safe (files are moved untouched, in this exact
order):

```bash
cd <repo>/..
mkdir <repo>.migrating
mv <repo> <repo>.migrating/main
mv <repo>.migrating/main/.git <repo>.migrating/.git
git config --file=<repo>.migrating/.git/config core.worktree ../main
mv <repo>.migrating <repo>
```

**Verify after either:**

```bash
git -C <container>/main rev-parse --show-toplevel   # must print <container>/main
git -C <container>/main status                      # must list the repo's files as tracked
```

## Cleanup (after a branch is merged)

```bash
cd <container>
git worktree remove <name>      # add --force only if it has untracked leftovers
git branch -d <name>
git worktree prune
```

Remove the worktree and the branch together; a stale one without the other
defeats the layout.

## Hard rules (each pitfall is real)

- `core.worktree` must be **`../main`**, literally — **not** `main`. A bare
  `main` resolves *inside* `.git/` and every git command fails with
  `fatal: cannot chdir to 'main'` — including `git config` itself. Recovery:
  `git config --file=<container>/.git/config --unset-all core.worktree`, then
  set the correct value.
- Between `mv`-ing `.git` into place and setting `core.worktree`, **no ordinary
  git command works** — that's why configuration must use `git config --file=`
  in the same breath. Never leave a repo in this half-state.
- **Never run `git add -A` / commit when `git status` doesn't list the repo's
  files** as tracked. A redirected or half-migrated worktree makes tracked
  files invisible, and `add -A` then stages a deletion of the entire repo in
  one commit. Verify status first, always.
- Run git commands from inside a worktree (or `git -C <container>/<name>`);
  from the container root they operate on `main/` with confusing relative
  paths.
- If the agent platform offers a built-in worktree tool (e.g. OpenCode's
  `worktree_create`), use it only if it places the worktree inside this
  container with matching naming; otherwise use the git commands above.
