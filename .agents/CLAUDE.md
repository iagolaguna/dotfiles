# Dotfiles project

This is the dotfiles repo for Iago Laguna's macOS dev environment. Everything here is symlinked to its system location, so editing a file is the same as editing it in place.

## Key facts

- `agents/` holds shared AI tooling (rules and skills), symlinked to `~/.agents` and `~/.claude/`.
- `.agents/` (this folder) is scoped to this project. Rules and skills here only apply inside the dotfiles repo.
- `install.sh` is the source of truth for all symlinks. Edit it to add or change what gets linked.
- The global CLAUDE.md is `agents/AGENTS.md`, linked to `~/.claude/CLAUDE.md`. The root `CLAUDE.md` is a symlink to the root `AGENTS.md`, which documents the repo.

## Repo layout quick reference

| Folder | Purpose |
|--------|---------|
| `env/` | `.zshrc` and `.gitconfig` |
| `nvim/` | Neovim config (lazy.nvim) |
| `kitty/` | Kitty terminal config |
| `tmux/` | Minimal `.tmux.conf` |
| `better-tmux/` | TypeScript/React tmux status bar |
| `bin/` | `notification` and `worktree` scripts |
| `agents/` | Shared AI tooling, symlinked globally |
| `.agents/` | Dotfiles-specific Claude config (this folder) |
| `claude/` | Global Claude Code settings (symlinked to `~/.claude/settings.json`) |
| `opencode/` | Global opencode config (symlinked to `~/.config/opencode/opencode.json`) |
| `cursor/` | Cursor MCP config |

## Common tasks

- Add a global AI rule: create a file in `agents/rules/` and list it in `agents/AGENTS.md`
- Add a global skill: create a folder in `agents/skills/`
- Add a dotfiles-specific rule or skill: add to `.agents/`
- Change the tmux status bar: edit `better-tmux/index.tsx`
- Add a new symlink: edit `install.sh`, then re-run it
