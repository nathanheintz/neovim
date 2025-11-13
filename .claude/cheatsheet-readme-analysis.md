# Cheatsheet-Readme Directory Analysis

**Date**: 2025-11-13
**Purpose**: Evaluate files in `cheatsheet-readme/` directory to determine what to keep, update, or remove

---

## Files Currently in Directory

```
cheatsheet-readme/
├── ben-README.md                    # Ben's original README
├── claude-config-guidelines.md      # AI config guidelines (Ben's)
├── config-cheatsheet.md             # Ben's comprehensive config guide
├── deckset-cheatsheet.md            # Deckset presentation tool reference
├── lazygit-cheatsheet.md            # LazyGit commands
├── lectic-cheatsheet.md             # Lectic AI assistant reference
├── nh-README.md                     # Your personal notes/draft README
├── nvim-generic-cheatsheet.md       # Generic Vim/Neovim commands
└── nvim-cheatsheet.md               # MOVED to /CHEATSHEET.md
```

---

## File-by-File Analysis

### 1. nvim-cheatsheet.md
**Status**: ✅ MOVED to main directory as `CHEATSHEET.md`

**Action Taken**:
- Updated Lectic section (single-party, 12 personas, removed multi-party references)
- Moved to `~/.config/nvim/CHEATSHEET.md`

**Reason**: This is your primary reference document for your config-specific commands.

---

### 2. lectic-cheatsheet.md
**Status**: ✅ KEEP (needs minor update)

**Current State**: Mostly accurate, documents single-party workflow

**Recommendation**:
- **Keep as reference** - Technical details useful for troubleshooting
- **Minor update needed**: Line 6 description says "(Homie)" but should clarify it creates with Homie by default

**Location**: Keep in `cheatsheet-readme/` as supplementary documentation

**Value**:
- Documents persona definitions and locations
- Technical implementation details
- Frontmatter format examples
- More detailed than CHEATSHEET.md

---

### 3. nvim-generic-cheatsheet.md
**Status**: ✅ KEEP

**Content**: Generic Vim/Neovim commands (movement, editing, etc.)

**Recommendation**: **Keep as learning resource**

**Reason**:
- 47KB of generic Neovim wisdom
- Not config-specific, but universally useful
- Good reference when you forget standard Vim commands
- Doesn't clutter - it's supplementary

**Suggested rename**: Already well-named ("generic")

---

### 4. deckset-cheatsheet.md
**Status**: ⚠️ EVALUATE - Do you use Deckset?

**Content**: Deckset presentation tool markdown syntax

**Recommendation**:
- **If you use Deckset**: Keep it
- **If you don't**: Remove it (Ben's tool, not yours)

**Question for you**: Do you create presentations with Deckset?

---

### 5. lazygit-cheatsheet.md
**Status**: ✅ KEEP (possibly update)

**Content**: LazyGit keybindings and commands (1258 bytes - very concise)

**Current state**: Basic commands from June

**Recommendation**: **Keep and potentially expand**

**Reason**:
- You use LazyGit (via Snacks.nvim `<leader>gg`)
- Short enough to be useful without bloat
- Could add more advanced commands as you learn them

---

### 6. ben-README.md
**Status**: ❌ REMOVE

**Content**: Ben's NeoTex configuration README (describes his setup, not yours)

**Recommendation**: **Delete**

**Reasons**:
- Describes Ben's config (VimTeX, Zotero, NixOS focus)
- You have your own README.md now
- Outdated for your use case (no VimTeX, different workflow)
- Historical artifact from fork

**What to preserve**: Nothing - you've already documented what you kept

---

### 7. nh-README.md
**Status**: ❌ REMOVE (or archive)

**Content**: Your early draft README with notes/frontmatter examples

**Recommendation**: **Delete - already incorporated into real README**

**Reasons**:
- Rough draft/notes format
- Most content already in your main README.md
- The Lectic frontmatter examples now in lectic-cheatsheet.md
- "My Neovim Stack" section at bottom is informal notes

**What to preserve**: Nothing - already documented elsewhere

---

### 8. config-cheatsheet.md
**Status**: ❌ REMOVE

**Content**: Ben's comprehensive config guide (23KB) - VimTeX, Avante, NixOS focused

**Recommendation**: **Delete**

**Reasons**:
- **Heavy Ben focus**: VimTeX, LaTeX templates, NixOS package management
- **Not your workflow**: You don't use VimTeX, NixOS, or most Ben-specific features
- **Outdated Avante info**: You don't use Avante (you use Lectic)
- **Duplication**: Generic vim commands duplicated in nvim-generic-cheatsheet.md

**What to preserve**: Nothing unique to your config

---

### 9. claude-config-guidelines.md
**Status**: ❌ REMOVE

**Content**: Ben's guidelines for AI-assisted config editing (1222 bytes)

**Recommendation**: **Delete**

**Reasons**:
- Ben's personal guidelines for how AI should edit his config
- You have your own `.claude/` workflow system now (research/plan/implement)
- Outdated approach (you're using structured specs, not guidelines files)

---

## Summary Recommendations

### ✅ KEEP (4 files)

1. **lectic-cheatsheet.md** - Technical reference for Lectic
2. **lazygit-cheatsheet.md** - LazyGit commands
3. **nvim-generic-cheatsheet.md** - Generic Vim/Neovim reference
4. **deckset-cheatsheet.md** - *Only if you use Deckset for presentations*

### ❌ REMOVE (5 files)

1. **ben-README.md** - Ben's config README (not relevant)
2. **nh-README.md** - Your draft README (superseded)
3. **config-cheatsheet.md** - Ben's comprehensive guide (not your workflow)
4. **claude-config-guidelines.md** - Ben's AI guidelines (superseded by `.claude/`)
5. **deckset-cheatsheet.md** - *Only if you DON'T use Deckset*

### ✅ ALREADY MOVED (1 file)

1. **nvim-cheatsheet.md** → `/CHEATSHEET.md` (your primary reference)

---

## Proposed Directory Structure

**After cleanup:**

```
~/.config/nvim/
├── README.md                        # Your main config documentation
├── CHEATSHEET.md                    # Your config-specific commands (MOVED)
└── cheatsheet-readme/               # Supplementary references
    ├── lectic-cheatsheet.md         # Lectic technical details
    ├── lazygit-cheatsheet.md        # LazyGit commands
    ├── nvim-generic-cheatsheet.md   # Generic Vim wisdom
    └── deckset-cheatsheet.md        # (optional - only if you use it)
```

**Total**: 3-4 supplementary docs (down from 10)

---

## Rationale

### Why Keep These?

**lectic-cheatsheet.md**:
- Technical implementation details you might need
- Persona definitions and locations
- Frontmatter format examples
- Troubleshooting reference

**lazygit-cheatsheet.md**:
- You actively use LazyGit
- Concise and useful
- Easy to expand as you learn

**nvim-generic-cheatsheet.md**:
- Not config-specific but universally useful
- 47KB of Vim knowledge
- Good when you forget standard commands

**deckset-cheatsheet.md** (conditional):
- Only if you create presentations with it
- If not, it's Ben's tool

### Why Remove The Rest?

**Ben's files** (ben-README, config-cheatsheet, claude-config-guidelines):
- Different workflow (VimTeX, NixOS, Avante)
- Your config has diverged significantly
- You have your own documentation now

**Your drafts** (nh-README):
- Superseded by real README.md
- Content already incorporated

---

## Action Items

1. **Confirm with user**: Do you use Deckset for presentations?
2. **If yes to Deckset**: Keep it
3. **If no to Deckset**: Add to removal list
4. **Remove files**: Delete the 4-5 files marked for removal
5. **Update references**: Ensure README.md doesn't reference removed files

---

## Notes

- All Ben-specific features (VimTeX, Zotero, NixOS) removed from your config
- You use Lectic (not Avante) for AI assistance
- Your workflow is writing/zettelkasten focused (not LaTeX academic)
- `.claude/` system replaced ad-hoc guidelines approach
