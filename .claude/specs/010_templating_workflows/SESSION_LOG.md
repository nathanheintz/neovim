# Session Log: Templating Workflows

**Project**: 010 - Templating Workflows
**Created**: 2026-03-26

---

## Task Batch 1: Markdown Diagram & Matrix Snippets

**Date**: 2026-03-26

### Discussion:
- User wanted quick-insert snippets for illustrative diagrams in markdown (triangle, 4x4 matrix)
- Needed to understand how snippet triggering/completion works before choosing trigger words
- Wanted dynamic centering in the matrix (text updates padding live as you type)
- Trigger words: `triangle` (SnipMate), `4x4Matrix` + `matrix4x4` alias (LuaSnip Lua-native)

### Implementation:

**1. Triangle Diagram Snippet (SnipMate)**

File: `snippets/markdown.snippets`

- 6 tab stops: TOP LINE 1, TOP LINE 2, LEFT LINE 1, LEFT LINE 2, RIGHT LINE 1, RIGHT LINE 2
- Fixed-width ASCII art triangle
- Key technical challenge: LuaSnip reads first body line's leading whitespace and strips that many chars from ALL body lines — caused left side to be cut off. Fixed by writing a TAB-only first line so LuaSnip strips exactly 1 char (the TAB) from every line.

**2. 4x4Matrix Dynamic Snippet (LuaSnip Lua-native)**

File: `lua/snippets/markdown.lua` (new file)

- 12 tab stops in order: Top Axis, Bottom Axis, Left Axis, Right Axis, TL Name, TL Desc, TR Name, TR Desc, BR Name, BR Desc, BL Name, BL Desc
- Fixed width: 37 chars total (18 per half + `|` center divider)
- `cl()` / `ct()` function nodes: live-centering leading/trailing space as user types in any cell
- `lp()` / `rp()` for left/right axis label padding
- Two triggers registered: `4x4Matrix` and `matrix4x4` (same `matrix_nodes()` function called twice)
- Required adding `from_lua` loader to `lua/plugins/luasnip.lua`

**3. LuaSnip t("\n") Bug**

- Initial implementation used `t("\n")` and string concat for newlines → only first node rendered
- Fix: all newlines must use array format `t({"", "next line"})` in LuaSnip Lua-native snippets

### Files Created/Modified:
- `snippets/markdown.snippets` — Triangle diagram snippet
- `lua/snippets/markdown.lua` — 4x4Matrix + matrix4x4 dynamic snippets (new file)
- `lua/plugins/luasnip.lua` — Added `region_check_events`, added `from_lua` loader

### Tab Stop Order (4x4Matrix):
```
Tab 1:  TOP AXIS (top center)
Tab 2:  BOTTOM AXIS (bottom center)
Tab 3:  LEFT AXIS (left side of divider)
Tab 4:  RIGHT AXIS (right side of divider)
Tab 5:  TL NAME / Tab 6: TL DESC
Tab 7:  TR NAME / Tab 8: TR DESC
Tab 9:  BR NAME / Tab 10: BR DESC
Tab 11: BL NAME / Tab 12: BL DESC
```

### Decisions:
- SnipMate format for triangle (simpler, static content)
- LuaSnip Lua-native for matrix (requires dynamic function nodes for centering)
- Table snippets initially created then removed — vim-table-mode handles tables better
- `matrix4x4` added as second trigger so both `4x4` and `mat` prefix-match in completion

### Git Commit: cb7260e

---
