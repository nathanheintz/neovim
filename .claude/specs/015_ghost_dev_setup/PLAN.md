# 015: Ghost Dev Setup — Plan

**Status**: Not started
**Depends on**: 012 (Claude Workflow Optimization) — ghost-dev agent must exist; global read permissions for Ghost folders must be set
**CWD**: `~/ghostdev`

---

## Overview

Set up the Claude Code infrastructure for Ghost theme development:
1. Create `~/ghostdev/CLAUDE.md` — CWD orientation for Claude
2. Create `~/ghostdev/.claude/` — operational tracking structure
3. Verify ghost-dev agent is correctly configured (created in project 012)

---

## Agent Notes

**Before starting:** Invoke `nvim-dev` or `ghost-dev` agent.

**Ghost install context:**
- Local Ghost install: `~/.ghost/` and `~/ghostlocal/`
- Theme development directory: `~/ghostdev/`
- Two theme folders: `~/ghostdev/comp/` and `~/ghostdev/spotlight-og/`
- `spotlight-og/` is the primary active theme — full Ghost theme structure (HBS templates, assets, partials, rollup.config.js)
- Global read permissions for all three Ghost folders are set in `~/.claude/settings.json` (project 012)

**Ghost theme file types:**
- `.hbs` — Handlebars templates (Ghost's templating language)
- `package.json` — theme metadata and GSC (Ghost Compatibility) settings
- `rollup.config.js` — JS bundler config
- `assets/` — CSS, JS, images
- `partials/` — reusable HBS partials
- `locales/` — i18n files

**Ghost documentation:** `https://ghost.org/docs/themes/` (primary reference for the ghost-dev agent)

---

## Phase 1: `~/ghostdev/CLAUDE.md`

This file gives Claude orientation when the CWD is `~/ghostdev`. It should cover what the repo is, the theme structure, the local install, and constraints.

**Create `~/ghostdev/CLAUDE.md`:**

```markdown
# CLAUDE.md — ghostdev

This repository contains Ghost theme development work.

## What This Is

Ghost (https://ghost.org) is a Node.js publishing platform. This directory contains
custom theme development for nathanheintz.com.

## Directory Structure

| Folder | Purpose |
|---|---|
| `spotlight-og/` | Primary active theme (modified from Spotlight) |
| `comp/` | Component experiments / scratchpad |

## spotlight-og Theme Structure

| File/Folder | Purpose |
|---|---|
| `default.hbs` | Base layout template |
| `index.hbs` | Homepage |
| `post.hbs` | Single post view |
| `page.hbs` | Static page view |
| `partials/` | Reusable HBS components |
| `assets/` | CSS, JS, images |
| `package.json` | Theme metadata and Ghost compatibility settings |
| `rollup.config.js` | JS bundler (Rollup) configuration |

## Local Install

- Ghost install: `~/.ghost/`
- Local running instance: `~/ghostlocal/`
- Start local Ghost: refer to Ghost CLI docs (`ghost start` from `~/ghostlocal/`)

## Agent

Use the `ghost-dev` agent for theme work. It has Ghost theme documentation
pre-loaded and knows this directory structure.

## Constraints

- Edit `.hbs` source and `assets/` source files — not compiled output
- Ghost uses Handlebars templating — syntax is `{{expression}}`, `{{#block}}`, `{{> partial}}`
- Ghost's data helpers (`{{#get}}`, `{{#foreach}}`, etc.) differ from standard Handlebars
- Theme changes require Ghost restart or theme re-upload to take effect locally
```

---

## Phase 2: `~/ghostdev/.claude/` Structure

Following the medium-weight infrastructure pattern (specs/ + maintenance log):

```
~/ghostdev/.claude/
├── MAINTENANCE_LOG.md    — small fixes, tweaks, debugging
└── specs/                — project folders for larger theme features
```

**Create `~/ghostdev/.claude/MAINTENANCE_LOG.md`:**

```markdown
# Ghost Dev Maintenance Log

Small fixes, tweaks, and debugging sessions.

## Format

### YYYY-MM-DD — Brief Description
**Task**: What was done
**Files**: Files modified
**Notes**: Any relevant context
```

The `specs/` directory starts empty — populate as Ghost theme projects are initiated.

---

## Phase 3: Verify ghost-dev Agent

The `ghost-dev` agent is created in project 012. Verify it is correctly configured:

- [ ] Read `~/.claude/agents/ghost-dev.md`
- [ ] Confirm it has:
  - Read access to `~/.ghost/**`, `~/ghostdev/**`, `~/ghostlocal/**`
  - Ghost theme docs URL: `https://ghost.org/docs/themes/`
  - Knowledge of the spotlight-og theme structure
  - Scope note: Ghost-specific, does not bleed into nvim/SecondBrain context
- [ ] If any of the above is missing, propose corrections to the agent file

---

## Steps

- [ ] Create `~/ghostdev/CLAUDE.md` with content from Phase 1
- [ ] Create `~/ghostdev/.claude/` directory
- [ ] Create `~/ghostdev/.claude/MAINTENANCE_LOG.md`
- [ ] Create `~/ghostdev/.claude/specs/` directory
- [ ] Verify ghost-dev agent configuration (Phase 3)
- [ ] Test: open a Claude Code session from `~/ghostdev/` CWD, confirm CLAUDE.md loads and ghost-dev agent is available

---

## Completion Checklist

- [ ] `~/ghostdev/CLAUDE.md` created
- [ ] `~/ghostdev/.claude/MAINTENANCE_LOG.md` created
- [ ] `~/ghostdev/.claude/specs/` directory exists
- [ ] ghost-dev agent verified
- [ ] Test session from ghostdev CWD confirms correct context load
