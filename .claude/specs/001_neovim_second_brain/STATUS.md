# Lectic Context File Loading - Current Status

**Date**: 2025-11-10 Early Afternoon
**Status**: RESOLVED - Working syntax found

## Solution

**Working syntax for context file loading:**
```yaml
interlocutor:
  name: Design Writer
  prompt: file:/Users/nathanheintz/SecondBrain/1-Projects/Book-Meditation/Meditation-Book-Posture-of-Mind.md
    You are a design writer with minimalist style...
```

**Key requirements:**
- Use **absolute paths** (`/Users/...`) NOT tilde (`~`) or relative paths
- `file:` prefix loads file contents, then rest of prompt field provides persona instructions
- Both context file and persona description work in same `prompt:` field

## What Works

✅ **Persona system functional**:
- 4 personas created (writer, editor, researcher, business)
- Dashboard shortcut `n` creates new file with persona selection
- Which-key submenu `<leader>mp` switches personas
- Frontmatter combines Obsidian + Lectic fields correctly

✅ **Obsidian compatibility**:
- Fields ordered correctly: `id`, `aliases`, `tags`, `interlocutor`
- Subfields alphabetized: `name`, `prompt`, `reminder`
- Obsidian doesn't rewrite frontmatter if properly formatted

✅ **Basic Lectic usage**:
- `:Lectic` command processes files
- Visual selection with `<leader>mS` works
- Personas respond correctly

## What Doesn't Work

❌ **Context file loading**:
- `file:` prefix in `prompt` field doesn't load file contents
- Tested syntax: `prompt: file:~/path.md You are a writer...`
- Result: Lectic treats path as literal text
- File contents never loaded into conversation

## Testing Results

### Test 1: Blank lines without `|` indicator
```yaml
prompt: file:~/path.md

   You are a design writer...
```
**Result**: YAML parse error (missing interlocutor)

### Test 2: Empty `reminder:` field
```yaml
interlocutor:
  name: Design Writer
  prompt: You are a design writer...
  reminder:
```
**Result**: YAML parse error ("Header is missing something")

### Test 3: Removed empty field
```yaml
interlocutor:
  name: Design Writer
  prompt: You are a design writer...
```
**Result**: ✅ Parses correctly, no issues

### Test 4: Single-line `file:` prefix (CRITICAL TEST)
```yaml
interlocutor:
  name: Design Writer
  prompt: file:~/SecondBrain/1-Projects/Book-Meditation/Meditation-Book-Posture-of-Mind.md
    You are a design writer with a minimalist, accessible style...
```
**Result**: ❌ Lectic responds but can't access file. Says:
> "I don't actually have access to your 'Posture of Mind' file. When you included the file path... This was just text that I can see..."

## Hypothesis (Untested)

The `file:` prefix may need to be on its own line with multiline YAML syntax:

```yaml
interlocutor:
  name: Design Writer
  prompt: |
    file:~/SecondBrain/context.md

    You are a design writer with minimalist style...
```

**Status**: NOT TESTED YET

## Known Constraints

1. **Empty YAML fields break parsing** - omit fields with no value
2. **Multiline strings need `|` indicator** - blank lines require proper syntax
3. **Obsidian rewrites frontmatter** - if it has gaps or comments
4. **`memories:` field deprecated** - removed July 2025, use `file:` prefix
5. **`prompt` vs `reminder`**:
   - `prompt`: Loads ONCE at start (good for context files)
   - `reminder`: Adds to EVERY message (expensive for large files)

## Files Modified

- `lua/plugins/lectic.lua`:
  - `CreateNewLecticFile()` - creates files with persona selection
  - `SwitchLecticPersona()` - switches personas, preserves `reminder` field
  - Persona templates in `init` section

- `.claude/specs/001_neovim_second_brain/SESSION_LOG.md`:
  - Added Session 3 Lectic persona system
  - Documented troubleshooting issues
  - Added Context Management Testing section with all test results

- `.claude/specs/001_neovim_second_brain/SPEC.md`:
  - Updated frontmatter format (removed `memories:`)
  - Added Technical Constraints section
  - Updated Phase 1/2 progress checkboxes
  - Marked `file:` loading as BLOCKED

- `README.md` and `cheatsheet-readme/nvim-cheatsheet.md`:
  - Added persona documentation
  - Updated keybindings
  - **NOTE**: May need updating once `file:` prefix works

## Major Design Change Required

**Current implementation is WRONG:**
- We built `CreateNewLecticFile()` and `SwitchLecticPersona()` functions
- These create separate files and replace frontmatter
- This is NOT how Lectic is designed to work

**Correct Lectic design:**
- Define ALL personas in ONE frontmatter using `interlocutors:` (plural)
- Switch between them during conversation using `:ask[PersonaName]` directive
- All personas available in same conversation thread

**Example:**
```yaml
---
interlocutors:
  - name: Writer
    prompt: You are a writer...
  - name: Editor
    prompt: You are an editor...
  - name: Researcher
    prompt: You are a researcher...
---

:ask[Researcher]
Can you research this topic?

:ask[Writer]
Now write about it.

:ask[Editor]
Edit this piece.
```

## Next Steps

### Immediate (Required)
1. **PROTOTYPE**: Test multiparty interlocutor design with all 4 personas in one file
2. **VERIFY**: Test `:ask[Name]` switching works as intended
3. **DECIDE**: Keep current nvim functions or switch to Lectic's native design?
4. **UPDATE**: All documentation to reflect correct usage

### If Keeping Multiparty Design
1. Remove `SwitchLecticPersona()` function (use `:ask[Name]` instead)
2. Update `CreateNewLecticFile()` to create `interlocutors:` array with all 4 personas
3. Remove which-key persona switching menu
4. Document `:ask[Name]` workflow

### If Keeping Current Design
1. Update templates to use absolute paths for context files
2. Test that file loading works with current functions
3. Document as "simplified single-persona workflow"

## Research Resources

**Lectic source code examined**:
- `/Users/nathanheintz/.local/share/nvim/lazy/lectic/src/types/interlocutor.ts`
- `/Users/nathanheintz/.local/share/nvim/lazy/lectic/src/utils/loader.ts`
- `/Users/nathanheintz/.local/share/nvim/lazy/lectic/src/types/lectic.ts`

**Key finding**: `prompt` field loaded via `loadFrom()` at line 142 in lectic.ts

## Process Failures & Lessons Learned

**What went wrong:**
1. Claude never found Lectic documentation despite user asking multiple times
2. When blocked on finding docs, Claude pivoted to source code analysis instead of ASKING for help
3. User had to provide direct documentation links
4. Even after reading docs, Claude suggested tilde paths when docs clearly said absolute paths
5. User solved the problem through their own testing

**Root cause:**
- Claude is a solution-implementer, not a problem-identifier or problem-solver
- When blocked, Claude tries alternative approaches instead of STOPPING and asking for help
- Documentation questions were treated as code-reading exercises

**Corrective actions:**
- When documentation is requested and cannot be found: STOP and explicitly ask user for link
- When user asks "how is X intended to work?" - recognize this as DESIGN/DOCUMENTATION question
- Read documentation FIRST before any code analysis or implementation
- Don't proceed with workarounds when actual answer exists in documentation

## Session Context

This work is part of Session 3: Lectic Persona System (see SESSION_LOG.md).

Previous sessions:
- Session 1: Which-Key Cleanup (COMPLETED)
- Session 2: Dashboard Cleanup (COMPLETED)
- Session 3: Lectic Persona System (COMPLETED - needs redesign based on actual Lectic workflow)
