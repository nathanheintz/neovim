# Neovim Config — Claude Context

This is a writing and publishing-focused Neovim configuration (forked from NeoTex, heavily
diverged). It serves as the editor toolchain for `~/SecondBrain` (Obsidian/PARA vault) and
other projects.

## Full Context System

Detailed documentation lives in `.claude/`. At the start of any config session, run `/init`
to load full context:

- `.claude/PROJECT_CONTEXT.md` — config overview, tools, key file locations, workflow preferences
- `.claude/SESSION_PROTOCOL.md` — agent behavior guidelines, documentation rules, git protocol
- `.claude/NVIM_STANDARDS.md` — Lua coding standards, documentation conventions
- `.claude/GLOBAL_SUMMARY_LOG.md` — history of all completed projects

## Quick Reference

**Plugin manager**: lazy.nvim
**Plugin configs**: `lua/plugins/*.lua`
**Leader keybindings**: `lua/plugins/which-key.lua`
**Non-leader keybindings**: `lua/core/keymaps.lua`
**Core options**: `lua/core/options.lua` (includes CWD-based colorscheme auto-switch)
**Utility functions**: `lua/core/functions.lua`
**Deprecated plugins**: `lua/deprecated/` (inactive, do not edit)

## Cross-Repo Relationship

This config drives the editing experience in `~/SecondBrain`. Symptoms appearing in
SecondBrain markdown files (rendering, keymaps, bullets, completions) are usually caused
by config here. See `~/.claude/CLAUDE.md` for the full cross-repo diagnostic guide.

## Workflow Preferences

- Discuss before implementing — show proposed changes for approval
- Work incrementally, one task batch at a time
- Run `/init` at session start to load full context
- Document completed work per SESSION_PROTOCOL.md
