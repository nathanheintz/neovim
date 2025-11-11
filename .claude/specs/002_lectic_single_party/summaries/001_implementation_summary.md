# Implementation Summary: Lectic Single-Party Persona System

**Date**: 2025-11-11
**Spec**: `.claude/specs/002_lectic_single_party/`

## Overview

Converted Lectic configuration from multi-party mode (broken in beta6) to single-party mode with persona switching functionality. Added context link insertion feature and reorganized persona selection workflow.

## What Was Implemented

### 1. Context Link Insertion (`<leader>mc`)

**Location**: `lua/plugins/lectic.lua:219-226`, `lua/plugins/which-key.lua:328`

**Function**: `InsertContextLink()`
- Inserts `[Context](/Users/nathanheintz/SecondBrain/)` on new line
- Positions cursor after last `/` for immediate path completion
- Starts insert mode automatically
- User can complete path with `Ctrl+x Ctrl+f`

### 2. Single-Party Persona Switching (`<leader>mp`)

**Location**: `lua/plugins/lectic.lua:228-352`, `lua/plugins/which-key.lua:330-345`

**Function**: `SwitchLecticPersona(persona_name)`
- Reads current file frontmatter
- Preserves Obsidian metadata fields (`id`, `aliases`, `tags`)
- Updates only `interlocutor.name` and `interlocutor.prompt`
- Supports 12 personas:
  - Business: Consultant, Marketing, Finance, Product
  - Writing: Researcher, Writer, Editor
  - Workshop: Designer, Scholar, Scribe
  - General: Homie, Nomad

**Which-Key Menu**: `<leader>mp`
- `c` - Consultant
- `m` - Marketing
- `f` - Finance
- `p` - Product
- `r` - Researcher
- `w` - Writer
- `e` - Editor
- `d` - Designer
- `s` - Scholar
- `b` - Scribe
- `h` - Homie
- `n` - Nomad

### 3. Simplified File Creation (`<leader>mn`)

**Location**: `lua/plugins/lectic.lua:187-189`

**Behavior Changed**:
- **Before**: Prompted for mode selection (business/writing/workshop/homie/nomad/test)
- **After**: Always creates file with Homie persona by default
- User switches to other personas via `<leader>mp` after creation

### 4. Multi-Party Code Disabled

**Location**: `lua/plugins/lectic.lua` (multiple sections)

**Changes**:
- Commented out multi-party persona modes (business, writing, workshop, test) - lines 27-96
- Commented out multi-party frontmatter generation - lines 118-131
- Commented out test mode template logic - lines 137-151
- Removed multi-party options from file creation menu - lines 189-213
- Removed .lec extension logic (test mode only) - lines 165-170

**Reason**: Multi-party conversations with `:ask[Name]` directives are broken in Lectic beta6

## Configuration Changes

### Which-Key Menu Structure

**Before**:
```
<leader>m
  l - Run Lectic
  n - New Lectic file (multiparty)
  S - Submit selection
```

**After**:
```
<leader>m
  l - Run Lectic
  n - New Lectic file (Homie)
  c - Insert context link
  p - Switch persona submenu
  S - Submit selection
```

### Frontmatter Format

**Before (Multi-Party)**:
```yaml
---
id:
aliases: []
tags: []
interlocutors:
  - name: Consultant
    provider: anthropic
    prompt: You are a business expert.
  - name: Marketing
    provider: anthropic
    prompt: You are a marketing expert.
---

:ask[Consultant]
Question for Consultant

:ask[Marketing]
Question for Marketing
```

**After (Single-Party)**:
```yaml
---
id:
aliases: []
tags: []
interlocutor:
  name: Homie
  prompt: You are a logician, philosopher...
---

Question for Homie
```

## User Workflow Changes

### Creating and Using Lectic Files

**Before**:
1. `<leader>mn` → Select mode (business/writing/workshop/homie/nomad)
2. File created with multiple personas in frontmatter
3. Use `:ask[PersonaName]` to switch between personas
4. **Problem**: Persona switching broken, produces undefined errors

**After**:
1. `<leader>mn` → File created with Homie persona
2. (Optional) `<leader>mp` → Switch to desired persona
3. (Optional) `<leader>mc` → Add context files with path completion
4. Write questions/content directly (no `:ask` directive needed)
5. `<leader>ml` → Run Lectic

### Adding Context Files

**Before**: Manual typing of full markdown link syntax
```markdown
[Context](/Users/nathanheintz/SecondBrain/path/to/file.md)
```

**After**: Quick insertion with path completion
1. `<leader>mc` → Inserts template with cursor positioned
2. `Ctrl+x Ctrl+f` → Complete file path
3. Type or edit description as needed

## Files Modified

### Core Implementation
- `lua/plugins/lectic.lua`
  - Added `InsertContextLink()` function (line 219)
  - Added `all_personas` table (line 228)
  - Added `SwitchLecticPersona()` function (line 280)
  - Commented out multi-party modes (lines 27-96)
  - Simplified `CreateNewLecticFile()` (line 187)
  - Commented out multi-party frontmatter logic (lines 118-131)
  - Commented out test mode template logic (lines 137-151)

### Keybindings
- `lua/plugins/which-key.lua`
  - Added `<leader>mc` - Insert context link (line 328)
  - Added `<leader>mp` submenu - Persona switching (lines 330-345)
  - Updated `<leader>mn` description (line 326)

### Documentation
- `cheatsheet-readme/lectic-cheatsheet.md`
  - Updated Key Commands section with new keybindings
  - Added Persona Switching Menu section
  - Revised Persona Modes section
  - Updated Adding Context Files section
  - Rewrote Frontmatter Examples (single-party focus)
  - Added Switching Personas section
  - Updated Technical Details section
- `README.md`
  - Updated Quick Reference with new keybindings

## Testing Verification

### Context Link Insertion
- [x] `<leader>mc` inserts correct template
- [x] Cursor positioned after last `/`
- [x] Insert mode starts automatically
- [x] Path completion works with `Ctrl+x Ctrl+f`

### Persona Switching
- [x] All 12 personas accessible via `<leader>mp`
- [x] Frontmatter updates correctly
- [x] Obsidian fields preserved (`id`, `aliases`, `tags`)
- [x] Single-party format maintained (`interlocutor:` not `interlocutors:`)

### File Creation
- [x] `<leader>mn` creates file with Homie persona
- [x] No mode selection prompt appears
- [x] Frontmatter uses single-party format
- [x] File saved with `.md` extension

## Known Limitations

1. **Multi-Party Disabled**: Cannot use multiple personas in same file with `:ask[Name]` directives (Lectic beta6 bug)
2. **Manual Switching Required**: Must use `<leader>mp` to change personas (cannot switch within conversation)
3. **Context Path Hardcoded**: Context link insertion uses hardcoded SecondBrain path
4. **No Persona Memory**: Switching personas updates frontmatter but doesn't preserve conversation context

## Future Considerations

### When Multi-Party is Fixed
- Uncomment multi-party code sections in `lectic.lua`
- Restore multi-party mode options (business, writing, workshop)
- Re-enable `:ask[Name]` directive usage
- Update documentation to reflect multi-party workflows

### Potential Enhancements
- Make context path configurable
- Add recent context files menu
- Implement persona history/favorites
- Add persona descriptions in switching menu
- Support multiple context file insertion at once

## Git Commit

**Branch**: nvim-custom

**Commit Message**:
```
feat: implement single-party Lectic persona system

Add persona switching and context link insertion:
- <leader>mc to insert context links with path completion
- <leader>mp submenu to switch between 12 personas
- Simplified <leader>mn to always create Homie files
- Persona switching preserves Obsidian frontmatter

Disable multi-party code:
- Comment out multi-party modes (broken in beta6)
- Remove :ask[Name] directive usage
- Use interlocutor (singular) format only

Update documentation:
- lectic-cheatsheet.md with new workflows
- README.md quick reference

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## References

- Lectic documentation: https://github.com/gleachkr/Lectic
- Bug report: `lectic-bug-report.md`
- Test files: `~/SecondBrain/test-single-party.md`
