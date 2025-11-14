# Lectic Single-Party Persona System - Session Log

## Session 1: 2025-11-11 - Single-Party Implementation

### Context
Multi-party Lectic conversations broken in beta6. Using `:ask[PersonaName]` directive produces error:
```
<error>Something went wrong when executing a command:<stdout from="PersonaName">undefined</stdout><stderr from="PersonaName">undefined</stderr></error>
```

Need working AI assistant for writing, so implementing single-party workaround with manual persona switching.

### Task Batch 1: Problem Investigation
**Discussion**:
- Attempted to implement multi-party conversations with 12 personas
- Tested `:ask[Name]` directive - produces undefined errors
- Confirmed this is Lectic beta6 bug, not configuration issue
- Discussed alternatives: single-party with manual switching vs waiting for fix
- User needs working system now, decided to implement single-party

**Implementation**:
- Tested multi-party format with `interlocutors:` (plural)
- Confirmed `:ask[Name]` broken
- Researched Lectic documentation for alternatives

**Testing**: Multi-party confirmed non-functional in beta6

**Decisions**:
- Use single-party mode with `interlocutor:` (singular)
- Implement manual persona switching via which-key menu
- Comment out all multi-party code with reason notes
- Plan to restore multi-party when Lectic fixes bug

**Git Commit**: [not yet]

### Task Batch 2: Single-Party Persona System
**Discussion**:
- Need to support 12 personas across 4 categories (Business, Writing, Workshop, General)
- Persona switching should preserve Obsidian frontmatter fields
- Default persona should be Homie (general-purpose)
- Which-key submenu provides best UX for switching

**Implementation**:
Created three key functions in `lua/plugins/lectic.lua`:

1. **`all_personas` table** (line 228):
   - Stores all 12 persona definitions with name and prompt
   - Organized by category: business (4), writing (3), workshop (3), general (2)
   - Each persona has full system prompt text

2. **`SwitchLecticPersona(persona_name)`** (line 280):
   - Reads current buffer to find frontmatter
   - Extracts Obsidian fields: `id`, `aliases`, `tags`
   - Finds new persona from `all_personas` table
   - Constructs new frontmatter preserving Obsidian fields
   - Updates only `interlocutor.name` and `interlocutor.prompt`
   - Replaces old frontmatter in buffer

3. **`CreateNewLecticFile()`** (line 187) - simplified:
   - Removed multi-party mode selection
   - Always creates file with Homie persona
   - User switches after creation if needed

**Files Modified**:
- `lua/plugins/lectic.lua` (lines 187-352):
  - Added `all_personas` table
  - Added `SwitchLecticPersona()` function
  - Simplified `CreateNewLecticFile()`
  - Commented out multi-party modes (lines 27-96)
  - Commented out multi-party frontmatter (lines 118-131)
  - Commented out test mode logic (lines 137-151)

**Testing**:
- Created test file with Homie persona
- Switched to all 12 personas successfully
- Verified Obsidian fields preserved
- Confirmed single-party format maintained

**Decisions**:
- Always create new files with Homie (safest default)
- Use frontmatter update approach (not template replacement)
- Preserve all Obsidian fields to prevent rewriting

**Git Commit**: [pending]

### Task Batch 3: Context File Loading
**Discussion**:
- Lectic deprecated `memories:` field in July 2025
- Attempted to use `file:` prefix in frontmatter `prompt:` field
- Testing showed file content not loading - Lectic sees path as literal text
- Alternative: Use markdown links in document body

**Implementation**:
Created `InsertContextLink()` function (line 219):
- Inserts `[Context](/Users/nathanheintz/SecondBrain/)`
- Moves cursor to end of path (after last `/`)
- Enters insert mode for immediate editing
- User completes path with `Ctrl+x Ctrl+f`

**Files Modified**:
- `lua/plugins/lectic.lua` (lines 219-226):
  - Added `InsertContextLink()` function
  - Hardcoded SecondBrain path (user's main vault)

**Testing**:
- `<leader>mc` inserts template correctly
- Cursor positioned for path completion
- `Ctrl+x Ctrl+f` completes file paths
- Markdown links successfully load context in Lectic

**Decisions**:
- Use markdown links in body, NOT `file:` prefix in frontmatter
- Use absolute paths (`/Users/...`), NOT tilde (`~`)
- Hardcode SecondBrain path (most common use case)

**Git Commit**: [pending]

### Task Batch 4: Which-Key Integration
**Discussion**:
- Need intuitive keybindings for 12 personas
- Submenu approach keeps which-key organized
- Single-letter mnemonics for each persona
- `<leader>m` already markdown menu, add `p` for personas

**Implementation**:
Updated `lua/plugins/which-key.lua`:

1. **Context link insertion** (line 328):
   - `<leader>mc` - Insert context link

2. **Persona switching submenu** (lines 330-345):
   - `<leader>mp` opens submenu with 12 options:
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

3. **Updated descriptions**:
   - `<leader>mn` now says "New Lectic file (Homie)"

**Files Modified**:
- `lua/plugins/which-key.lua` (lines 326-345)

**Testing**:
- All 12 persona switches work from which-key menu
- Context link insertion works
- No which-key errors or conflicts

**Decisions**:
- Use `c` for context (not `i` for insert)
- Use `p` for personas (not conflicting with existing)
- Mnemonic letters match persona names where possible

**Git Commit**: [pending]

### Task Batch 5: Multi-Party Code Cleanup
**Discussion**:
- Don't delete multi-party code - may be useful when bug fixed
- Comment out with clear reason notes
- Document which sections are disabled
- Make easy to restore later

**Implementation**:
Added comments throughout `lua/plugins/lectic.lua`:
- "MULTI-PARTY DISABLED: Multi-party conversations are broken in Lectic beta6"
- Marked all disabled sections with this comment
- Commented out but kept code intact

**Sections Disabled**:
- Multi-party persona modes (business, writing, workshop, test) - lines 27-96
- Multi-party frontmatter generation - lines 118-131
- Test mode template logic - lines 137-151
- Multi-party mode selection - lines 189-213
- .lec extension logic (test mode) - lines 165-170

**Files Modified**:
- `lua/plugins/lectic.lua` (lines 27-213)

**Testing**: No errors from commented code

**Decisions**:
- Keep code for future restoration
- Clear commenting for context
- Document in SESSION_LOG for future reference

**Git Commit**: [pending]

### Task Batch 6: Documentation Updates
**Discussion**:
- Lectic cheatsheet needs complete rewrite for single-party
- README quick reference needs new keybindings
- Should document multi-party as disabled, not deleted

**Implementation**:
1. **Rewrote `cheatsheet-readme/lectic-cheatsheet.md`**:
   - Updated Key Commands section with new keybindings
   - Added Persona Switching Menu with all 12 personas
   - Revised Persona Modes section (single-party focus)
   - Updated Adding Context Files (markdown links, not `file:`)
   - Rewrote Frontmatter Examples (single-party format)
   - Added Switching Personas section
   - Updated Technical Details with current constraints
   - Documented multi-party as disabled

2. **Updated `README.md`**:
   - Added new keybindings to quick reference
   - Updated Lectic section with current workflow

**Files Modified**:
- `cheatsheet-readme/lectic-cheatsheet.md` (complete rewrite)
- `README.md` (quick reference section)

**Testing**: Documentation reviewed for accuracy

**Decisions**:
- Document current state honestly (multi-party broken)
- Provide clear workflow for single-party usage
- Include troubleshooting notes for common issues

**Git Commit**: 065c7c6

### Session End State
**Completed**:
- ✅ Single-party persona system functional
- ✅ All 12 personas accessible via `<leader>mp`
- ✅ Context file loading via markdown links
- ✅ Multi-party code commented out (not deleted)
- ✅ Documentation updated for single-party workflow
- ✅ Git commit created

**Not Done**:
- N/A - All planned work completed

**Next Session**:
- Monitor Lectic updates for multi-party bug fix
- Consider making context path configurable
- Possibly add persona descriptions in switching menu

## Git Commits

**Commit 065c7c6** - feat: implement single-party Lectic persona system
- Added persona switching and context link insertion
- Simplified file creation
- Commented out multi-party code
- Updated documentation

**Commit 1d36eeb** - chore: update configuration and documentation (included related changes)
