# Lectic AI Writing Assistant - Technical Reference

## Key Commands

### Creating Files
- `<leader>mn` - Create new Lectic file (Scholar default, Obsidian-compatible frontmatter)
- `<leader>mf` - Add Lectic frontmatter to existing Obsidian doc (Scholar as default persona)

### Running Lectic
- `<leader>ml` - Process entire buffer
- `<leader>mx` - Cancel/interrupt running Lectic request
- `<leader>mS` - Submit visual selection with message (visual mode)
- `:Lectic` - Process entire buffer
- `:Lectic {line1},{line2}` - Process specific line range

### Context & Persona Commands
- `<leader>mc` - Insert context link with path completion
- `<leader>mp` - Switch persona submenu (inserts `:ask[Name]` at cursor)

### Which-Key Menu (`<leader>m`)
```
<leader>m - MARKDOWN & WRITING
  z - Zen mode
  w - Write all
  l - Run Lectic on file
  n - New Lectic file (Scholar)
  f - Add Lectic frontmatter (Scholar)
  c - Insert context link
  p - Switch persona submenu
  S - Submit selection with message
  v - Markdown preview
  u - Open URL under cursor
  s - Surround submenu
  t - Toggles submenu (completion, folding)
```

### Persona Switching Menu (`<leader>mp`)
```
<leader>mp - SWITCH PERSONA (inserts :ask[Name] at cursor)
  c - Consultant
  m - Marketing
  f - Finance
  p - Product
  r - Researcher (has paper_search tool)
  w - Writer
  e - Editor
  d - Designer
  s - Scholar
  b - Scribe
  h - Homie
  n - Nomad
```

## How Multi-Party Works (v0.0.3)

True multi-party mode is working as of 2026-04-12. All 12 personas are defined globally in
`~/Library/Preferences/lectic/lectic.yaml` (Lectic's system config on macOS). This config
merges into every document automatically — no persona prompts needed in frontmatter.

**To switch personas mid-conversation:**
1. Press `<leader>mp` and select a persona (e.g. `e` for Editor)
2. `:ask[Editor]` is inserted at the cursor on a new line
3. Continue typing your message on the same line after the directive
4. Run Lectic — all subsequent responses come from Editor

**`:ask[Name]`** — permanently switches the active speaker for all turns that follow.
**`:aside[Name]`** — single-turn switch; reverts to previous speaker after one response.

## Frontmatter

Minimal frontmatter — Lectic pulls the full persona config from the system yaml:

```yaml
---
id:
aliases: []
tags: []
interlocutor:
  name: Scholar
  prompt:
---
```

- `prompt:` can be empty — Lectic uses the persona definition from the system config
- No `provider:` needed
- All 12 personas available via `:ask[Name]` even with just Scholar declared

**To add this frontmatter to an existing Obsidian note:** `<leader>mf`

## Adding Context Files

Add markdown links to context files in the body of your document (not in frontmatter).

**Quick method:** Use `<leader>mc` to insert `[Context](/Users/nathanheintz/SecondBrain/)` with
cursor positioned for path completion (use `Ctrl+x Ctrl+f` to complete file paths).

**Requirements:**
- Use markdown link syntax: `[Description](/absolute/path)`
- Must use absolute paths (NOT `~/`)
- Place links in document body before asking questions

## Technical Details

### Where Personas Are Defined

All 12 personas are in `~/Library/Preferences/lectic/lectic.yaml` — Lectic's system config
on macOS. This is NOT `~/.config/lectic/lectic.yaml`, which Lectic silently ignores unless
the `LECTIC_CONFIG` env var is set.

**Personas**: Homie, Consultant, Marketing, Finance, Product, Researcher (paper_search tool),
Writer, Editor, Designer, Scholar, Scribe, Nomad

**paper_search**: Defined via `kits:` in the same system yaml. Researcher's entry uses
`tools: - kit: paper_search`. No inline MCP config in frontmatter.

### How Commands Work

**`CreateNewLecticFile()` (`<leader>mn`)**
1. Opens new buffer
2. Generates Obsidian-compatible frontmatter with Scholar as default interlocutor
3. Prompts for save location with date-based default filename
4. Saves file with `.md` extension

**`AddLecticFrontmatter()` (`<leader>mf`)**
1. Finds existing frontmatter boundaries
2. Collects Obsidian fields (id, aliases, tags), strips any existing interlocutor block
3. Appends `interlocutor: / name: Scholar / prompt:` to the frontmatter
4. Leaves all other Obsidian fields intact

**`InsertContextLink()` (`<leader>mc`)**
1. Inserts `[Context](/Users/nathanheintz/SecondBrain/)` on new line
2. Positions cursor after last `/`
3. Starts insert mode for immediate path completion

**`SwitchLecticPersona()` (`<leader>mp`)**
1. Inserts `:ask[PersonaName] ` on a new line at the current cursor position
2. Positions cursor at end of directive and enters insert mode
3. No frontmatter mutation — persona switching is inline via Lectic directives

**`SubmitLecticSelection()` (`<leader>mS`)**
1. Captures visual selection
2. Prompts for message/question
3. Appends selection + message to end of file
4. Submits entire file to Lectic
5. Response appended below

**`:Lectic` Command (`<leader>ml`)**
- Processes buffer or line range
- Calls `require("lectic.submit").submit_lectic()`
- Supports visual selections

### File Detection

- `.lec` files automatically set to `lectic.markdown` filetype
- `.md` files work with Lectic when frontmatter is present

### Configuration

**Model setting** (in `lua/plugins/lectic.lua`):
```lua
vim.g.lectic_model = "claude-sonnet-4-6"
```

**Concealment** (for lectic.markdown files):
- `conceallevel = 2` - Hides markdown syntax in normal/command mode
- `concealcursor = "nc"` - Shows syntax in insert mode
