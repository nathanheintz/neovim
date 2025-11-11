# Lectic Multi-Persona System - Implementation Summary

**Date**: 2025-11-10 Afternoon
**Status**: COMPLETE - Ready for testing

## What Was Built

### Multi-Persona Modes

Created 5 persona modes with succinct one-word names:

#### 1. Business Mode (4 personas)
- **Consultant** - Business strategy + professional services BD specialist
- **Marketing** - Marketing and storytelling specialist
- **Finance** - Finance expert
- **Product** - Product and service design expert

#### 2. Writing Mode (3 personas)
- **Researcher** - Logician, philosopher, neuroscientist, conflict resolution expert
- **Writer** - Design writer with minimalist, accessible style
- **Editor** - Nonfiction editor and storytelling expert

#### 3. Workshop Design Mode (3 personas)
- **Designer** - Workshop designer & facilitator with vast facilitation tool library
- **Scholar** - Scientific researcher for rigorous, cited research findings
- **Scribe** - Succinct writer for slide notes and workshop content

#### 4. Homie (1 persona)
- **Homie** - Aspirational generalist: logician, philosopher, political theorist, pedagogist, psychologist, psychonaut, systemic change, conflict resolution, social practice art expert

#### 5. Nomad (1 persona)
- **Nomad** - Travel planner & digital nomadism expert: travel hacks, cities, languages, visas, strategies, destinations

## Technical Implementation

### File: `lua/plugins/lectic.lua`
- **Removed**: `SwitchLecticPersona()` function (no longer needed)
- **Updated**: `CreateNewLecticFile()` to offer mode selection
- Creates multiparty frontmatter with `interlocutors:` array
- All personas in selected mode available in one conversation

### Frontmatter Structure
```yaml
---
id:
aliases: []
tags: []
interlocutors:
  - name: Consultant
    prompt: You are a business strategy expert...
  - name: Marketing
    prompt: You are a marketing and storytelling specialist...
  - name: Finance
    prompt: You are a finance expert...
  - name: Product
    prompt: You are a product and service design expert...
---
```

### Usage Workflow
1. Create new file: `<leader>mn`
2. Select mode (Business/Writing/Workshop/Homie/Nomad)
3. File created with ALL personas for that mode
4. Switch between personas in conversation:
   ```
   :ask[Consultant]
   Can you help me with strategy?

   :ask[Finance]
   What's the financial impact?
   ```

### Which-Key Menu Changes

#### Removed
- Old PERSONAS submenu (`<leader>mp`) - no longer needed with multiparty design

#### Reorganized
- **New TOGGLES submenu** (`<leader>mt`):
  - Buffer completion toggle
  - Spell completion toggle
  - Obsidian completion toggle
  - LuaSnip completion toggle
  - Fold toggles

#### Current Structure
```
<leader>m - MARKDOWN & WRITING
  z - Zen mode
  w - Write all
  l - Run Lectic
  n - New Lectic file (multiparty)
  S - Submit selection with message
  v - Markdown preview
  u - Open URL under cursor
  s - Surround submenu
  t - Toggles submenu (NEW)
```

### File: Path Auto-Completion

Added abbreviation in `lua/core/options.lua`:
- Type `file:` in markdown → auto-expands to `file:/Users/nathanheintz/SecondBrain/`
- Triggered on space/enter after typing `file:`
- Only active in markdown and lectic.markdown files

## Key Features

1. **Multiparty Conversations**: All personas in mode available simultaneously
2. **Obsidian Compatible**: Frontmatter follows Obsidian field ordering
3. **Context File Loading**: Use `prompt: file:/absolute/path.md` for context
4. **Mode Selection**: Choose appropriate persona set for task at hand
5. **Easy Path Entry**: `file:` abbreviation speeds up context file references

## Files Modified

- `lua/plugins/lectic.lua` - Complete rewrite with multiparty system
- `lua/plugins/which-key.lua` - Removed personas menu, added toggles submenu
- `lua/core/options.lua` - Added `file:` abbreviation

## Next Steps

1. **TEST** multiparty conversations with real writing task
2. **UPDATE** README.md with new workflow
3. **UPDATE** CHEATSHEET with new keybindings and usage
4. **Document** maintenance log entry

## Design Decisions

**Why multiparty over single-persona:**
- Matches Lectic's native design intent
- Enables consulting multiple experts in one conversation
- Cleaner than switching frontmatter
- More flexible for complex projects

**Why mode-based grouping:**
- Reduces frontmatter size vs all personas always
- Groups related experts for context
- Easier to choose appropriate set for task
- Individual modes (Homie/Nomad) for general use

**Why one-word names:**
- Faster to type in `:ask[Name]` directives
- Cleaner in conversation flow
- Easy to remember

## Known Constraints

- Use absolute paths for `file:` references (NOT tilde `~`)
- Frontmatter must follow Obsidian field order: `id`, `aliases`, `tags`, `interlocutors`
- `file:` abbreviation only works in insert mode
- Empty YAML fields cause parsing errors (don't include empty fields)
