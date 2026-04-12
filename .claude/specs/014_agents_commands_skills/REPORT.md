# 014: Lectic Multi-Party Investigation Report

**Date**: 2026-04-12
**Status**: Complete — root causes identified, solution clear

---

## Root Cause 1: Wrong Config File Path (macOS)

**The critical finding**: On macOS, Lectic's system config directory is NOT `~/.config/lectic/`. It is:

```
~/Library/Preferences/lectic/lectic.yaml
```

This is hardcoded in `src/utils/xdg.ts`:
```typescript
case 'darwin': {
    case 'config': return join(library, 'Preferences');
}
// → lecticConfigDir() = ~/Library/Preferences/lectic/lectic.yaml
```

`LECTIC_CONFIG` is unset in Nathan's environment, so Lectic always uses the macOS path.

**Everything put in `~/.config/lectic/lectic.yaml` is silently ignored.**

The file Lectic actually reads is `~/Library/Preferences/lectic/lectic.yaml`, which currently contains:

```yaml
kits:
  - name: paper_search
    tools:
      - name: paper_search
        mcp_command: /Users/nathanheintz/.local/share/paper-search-mcp-env/bin/python
        args:
          - "-m"
          - "paper_search_mcp.server"
```

---

## Root Cause 2: How kit: Works (and Why It Worked Before)

The `kits:` key at the top level of lectic.yaml defines named tool collections. An interlocutor can reference them with `- kit: <name>` in its `tools:` array.

From `src/types/lectic.ts`:
```typescript
private expandTools(tools: object[]): object[] {
    const idx = new Map<string, ToolKitSpec>()
    for (const b of this.kits) idx.set(b.name, b)
    const expandOne = (spec: object) => {
        if (spec && "kit" in spec && typeof spec.kit === 'string') {
            const kit = idx.get(name)
            if (!kit) throw Error(Messages.kit.unknownReference(name))
            for (const inner of kit.tools) expandOne(inner)
        }
    }
}
```

The `kits:` definition in `~/Library/Preferences/lectic/lectic.yaml` merges into every document's config. When a Researcher frontmatter had `tools: - kit: paper_search`, the kit was found via this merged config and expanded. **This was working correctly.**

What was broken was `SwitchLecticPersona` rewriting the entire `interlocutor:` block on every switch — which caused v0.0.3 history validation to fail when `:::PreviousPersona` blocks existed.

---

## Root Cause 3: How Global Interlocutors Work (Confirmed from Source)

From `src/parsing/parse.ts`, the merge pipeline:

1. Load system config YAML (`~/Library/Preferences/lectic/lectic.yaml`)
2. Load workspace config YAML (walk up from document dir looking for `lectic.yaml`)
3. Load document header YAML
4. Reduce: `[system, workspace, document].reduce(mergeValues)`

From `src/utils/merge.ts` — arrays merge by `name`:
```typescript
// Arrays: merged based on 'name' attribute of elements
// Objects sharing the same name are merged recursively
// Other elements are combined (concatenated)
```

**What this means**: If the system config has `interlocutors: [12 personas]` and the document has `interlocutor: {name: Scholar, prompt: ..., provider: anthropic}`, the merged spec has BOTH — `interlocutors` from system config AND `interlocutor` from document. The `LecticHeader` constructor then builds `this.interlocutors = [Scholar (merged), ...11 others]`.

`setSpeaker("Editor")` searches `this.interlocutors` — so all 12 would be accessible via `:ask[Name]`.

**This works — but only if the personas are in the right file.**

---

## Solution

### Step 1: Move personas to the correct file

All 12 personas and the `kits:` definition go in `~/Library/Preferences/lectic/lectic.yaml`:

```yaml
kits:
  - name: paper_search
    tools:
      - name: paper_search
        mcp_command: /Users/nathanheintz/.local/share/paper-search-mcp-env/bin/python
        args:
          - "-m"
          - "paper_search_mcp.server"

interlocutors:
  - name: Homie
    provider: anthropic
    prompt: "..."
  - name: Scholar
    provider: anthropic
    prompt: "..."
  - name: Researcher
    provider: anthropic
    prompt: "..."
    tools:
      - kit: paper_search
  ... (all 12)
```

Note: Researcher's `tools: - kit: paper_search` references the `kits:` entry in the same file.

### Step 2: Document frontmatter

With all 12 in the system config, the document only needs the active/default persona defined inline:

```yaml
---
id:
aliases: []
tags: []
interlocutor:
  name: Scholar
  prompt: "You are a logician..."
  provider: anthropic
---
```

- After merge, all 12 personas are available to `:ask[Name]`
- Obsidian sees simple flat YAML — no arrays, no nesting beyond one level
- `prompt` is a quoted single-line string — Obsidian handles this fine

### Step 3: SwitchLecticPersona stays as :ask[Name] insertion

The current implementation (insert `:ask[Name] ` at cursor) is correct for v0.0.3. No frontmatter mutation needed for persona switching.

### Step 4: AddLecticFrontmatter

The `<leader>mf` function writes Scholar's `interlocutor:` block to existing Obsidian docs. This is correct — it provides the default persona inline for the merge to work with.

---

## What Needs to Change

1. **`~/Library/Preferences/lectic/lectic.yaml`** — add all 12 personas; move Researcher's `tools: - kit: paper_search` inside its interlocutor entry
2. **`~/.config/lectic/lectic.yaml`** — this file is irrelevant on macOS; can be left as-is or cleaned up
3. **`lua/plugins/lectic.lua`** — no changes needed beyond what's already done
4. **`lua/plugins/which-key.lua`** — no changes needed

---

## Optional: Set LECTIC_CONFIG for clarity

To override the macOS default and use `~/.config/lectic/` (keeping the current file location):

```fish
# ~/.config/fish/config.fish
set -gx LECTIC_CONFIG ~/.config/lectic
```

This would make `~/.config/lectic/lectic.yaml` the system config. But since the `~/Library/Preferences/lectic/lectic.yaml` already exists and has the paper_search kit, it's simpler to just edit that file directly.

---

## Files Referenced

- `~/.local/share/nvim/lazy/lectic/src/utils/xdg.ts` — macOS config path (line: `case 'config': return join(library, 'Preferences')`)
- `~/.local/share/nvim/lazy/lectic/src/utils/merge.ts` — array/object merge logic
- `~/.local/share/nvim/lazy/lectic/src/types/lectic.ts` — `LecticHeader` constructor, `expandTools`, `setSpeaker`
- `~/.local/share/nvim/lazy/lectic/src/parsing/parse.ts` — `parseLectic`, merge pipeline
- `~/.local/share/nvim/lazy/lectic/src/utils/cli.ts` — `getIncludes`, config chain loading
- `~/.local/share/nvim/lazy/lectic/src/utils/configDiscovery.ts` — `resolveConfigChain`, system/workspace config resolution
