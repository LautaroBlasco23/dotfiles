# Dotfiles

This repository contains the files I use daily to work with my AI Agents (currently using Opencode and Claude Code).

I'm using opencode the most of the time (personal subscription) to work and to develop personal projects, so ./opencode/ configuration is better defined because of that.

Also, I'm currently using Neovim because I think it's faster and easier to use when working with Claude Code / Opencode in the terminal. So I have my own "minimalistic" configuration for it.

---

### Most important command from the repo:

```bash
alias oc='opencode --auto
```

to avoid allowing Opencode to work after each single step.

---

# How to use it

Clone the repository:

```bash
git clone git@github.com:lautaroblasco23/dotfiles.git ~/dotfiles
```

Run the sync (copies configs to `~/.config` and `~/.claude`):

```bash
cd ~/dotfiles && ./sync.sh
```

---

## Opencode Agents

```
plan → Most Important agent IMO. I always use this to talk with the LLM and to discuss next steps when working around something.
build → Main builder, I use this agent to implement code changes.
```

---

## Structure

| Repo Path   | Synced To                                |
| ----------- | ---------------------------------------- |
| `opencode/` | `~/.config/opencode`                     |
| `claude/`   | `~/.claude`                              |
| `nvim/`     | `~/.config/nvim`                         |
| `skills/`   | `~/.claude/skills`, `~/.config/opencode/skills` |

Notes:

- All repo files are synced, tracked or not; gitignored files and machine-local files (`claude/settings.local.json`) are excluded.
- Sync is one-way (repo → home). Local edits to the copied configs are overwritten on the next run.
- Sync wipes and re-copies: `~/.config/nvim` and the skills directories are removed entirely on each run; `~/.config/opencode` and `~/.claude` only have the repo-managed entries replaced, so machine-local files are never touched.

---

## Skills

Currently empty (my job related skills are not available xd).

---

Feel free to do whatever you want with this repository's data.
