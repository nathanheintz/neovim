# Lectic AI Writing Assistant - Technical Reference

## Key Commands

### Creating Files
- `<leader>mn` - Create new Lectic file (Homie)

### Running Lectic
- `<leader>ml` - Process entire buffer
- `<leader>mS` - Submit visual selection with message (visual mode)
- `:Lectic` - Process entire buffer
- `:Lectic {line1},{line2}` - Process specific line range

### Context & Persona Commands
- `<leader>mc` - Insert context link with path completion
- `<leader>mp` - Switch persona submenu (see below)

### Which-Key Menu (`<leader>m`)
```
<leader>m - MARKDOWN & WRITING
  z - Zen mode
  w - Write all
  l - Run Lectic on file
  n - New Lectic file (Homie)
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
<leader>mp - SWITCH PERSONA
  c - Consultant
  m - Marketing
  f - Finance
  p - Product
  r - Researcher
  w - Writer
  e - Editor
  d - Designer
  s - Scholar
  b - Scribe
  h - Homie
  n - Nomad
```

## Persona Modes

**IMPORTANT:** Multi-party conversations are broken in Lectic beta6, so only single-party modes work.

When creating a new file with `<leader>mn`, it starts with the Homie persona by default.

To use other personas (Consultant, Marketing, Finance, Product, Researcher, Writer, Editor, Designer, Scholar, Scribe, Nomad), use `<leader>mp` to switch personas.

## Adding Context Files

Add markdown links to context files in the body of your document (not in frontmatter).

**Quick method:** Use `<leader>mc` to insert `[Context](/Users/nathanheintz/SecondBrain/)` with cursor positioned for path completion (use `Ctrl+x Ctrl+f` to complete file paths).

**Example:**
```markdown
---
id: business-plan-2025
aliases: []
tags: []
interlocutor:
  name: Consultant
  prompt: You are a business strategy expert.
---

# Business Plan

Reference documents:
[Brand Guidelines](/Users/nathanheintz/SecondBrain/brand-guidelines.md)
[Market Research](/Users/nathanheintz/SecondBrain/market-research.md)

Question for business strategy expert
```

**Requirements:**
- Use markdown link syntax: `[Description](/absolute/path)`
- Must use absolute paths (NOT `~/`)
- Place links in document body before asking questions

## Frontmatter Examples

### Single-Party Format (Currently Working)
```yaml
---
id: essay-draft
aliases: []
tags: []
interlocutor:
  name: Writer
  prompt: You are a design writer with a minimalist, accessible style.
---
```

**Required field order:** `id`, `aliases`, `tags`, `interlocutor`

**Important:**
- Empty arrays must use `[]`, not blank lines
- Use `interlocutor:` (singular) not `interlocutors:` (plural)
- No `:ask[Name]` directive needed in single-party mode

### Multi-Party Format (DISABLED - Broken in beta6)
```yaml
---
# THIS FORMAT DOES NOT WORK IN CURRENT VERSION
# interlocutors:
#   - name: Consultant
#     prompt: You are a business strategy expert.
#   - name: Marketing
#     prompt: You are a marketing specialist.
---
```

Multi-party conversations with `:ask[Name]` directives are broken in Lectic beta6. Use single-party mode and switch personas with `<leader>mp` instead.

## Switching Personas

To change the active persona in your document:

1. Press `<leader>mp` to open the persona switching menu
2. Select the persona you want (e.g., `w` for Writer, `c` for Consultant)
3. The frontmatter updates automatically, preserving your `id`, `aliases`, and `tags`

**Available personas:** Consultant, Marketing, Finance, Product, Researcher, Writer, Editor, Designer, Scholar, Scribe, Homie, Nomad

---

## Technical Details

### Where Personas Are Defined

All persona definitions are in `~/.config/nvim/lua/plugins/lectic.lua`:
- `persona_modes` table (line 26) - for file creation
- `all_personas` table (line 228) - for persona switching

### How Commands Work

**`CreateNewLecticFile()` (`<leader>mn`)**
1. Opens new buffer
2. Generates single-party frontmatter with Homie persona and Obsidian fields
3. Prompts for save location
4. Saves file with `.md` extension

**`InsertContextLink()` (`<leader>mc`)**
1. Inserts `[Context](/Users/nathanheintz/SecondBrain/)` on new line
2. Positions cursor after last `/`
3. Starts insert mode for immediate path completion

**`SwitchLecticPersona()` (`<leader>mp`)**
1. Reads current frontmatter
2. Preserves Obsidian fields (`id`, `aliases`, `tags`)
3. Updates `interlocutor.name` and `interlocutor.prompt` only
4. Writes new frontmatter back to file

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
vim.g.lectic_model = "claude-3-7-sonnet"
```

**Concealment** (for lectic.markdown files):
- `conceallevel = 2` - Hides markdown syntax in normal/command mode
- `concealcursor = "nc"` - Shows syntax in insert mode
