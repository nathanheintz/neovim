# Next Session Pickup - Lectic Redesign

**Date**: 2025-11-10 Early Afternoon
**Session**: 3 (Lectic Persona System)

## What We Just Learned

### Working Solution Found
```yaml
interlocutor:
  name: Design Writer
  prompt: file:/Users/nathanheintz/SecondBrain/path.md
    You are a design writer...
```

**Requirements:**
- Absolute paths (`/Users/...`) NOT tilde (`~`)
- `file:` prefix loads context, rest of field is persona description

### Lectic's Actual Design (Multiparty Conversations)

Lectic is designed for ALL personas in ONE file:

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
Research this topic.

:ask[Writer]
Write about it.

:ask[Editor]
Edit it.
```

Switch personas with `:ask[Name]` directive during conversation.

## What We Built (WRONG APPROACH)

- `CreateNewLecticFile()` - creates single-persona files
- `SwitchLecticPersona()` - replaces frontmatter
- Which-key menu for persona switching

**This ignores Lectic's native multiparty design.**

## Decision Required

### Option 1: Use Lectic's Native Multiparty Design
**Pros:**
- Works with Lectic's intended workflow
- All personas in one conversation
- Can switch between them fluidly
- No custom nvim functions needed

**Cons:**
- Frontmatter is longer (all personas defined)
- Need to type `:ask[Name]` to switch
- Different from what we built

**Implementation:**
1. Remove `SwitchLecticPersona()` function
2. Update `CreateNewLecticFile()` to create `interlocutors:` array
3. Remove which-key persona switching menu
4. Add which-key helper for `:ask[Name]` syntax

### Option 2: Keep Current Single-Persona Design
**Pros:**
- Simpler frontmatter per file
- Which-key menu for switching
- Already built

**Cons:**
- Fights against Lectic's design
- Each file has only one persona
- Can't consult multiple personas in same conversation

**Implementation:**
1. Update templates to use absolute paths
2. Keep existing functions
3. Document as "simplified workflow"

## Next Actions

1. **PROTOTYPE** - Test multiparty design with real writing task
2. **DECIDE** - Which approach fits your workflow better?
3. **IMPLEMENT** - Whichever option chosen
4. **DOCUMENT** - Update all docs/README/CHEATSHEET

## Context Files

- **STATUS.md** - Current state, solution details
- **SESSION_LOG.md** - Complete chronological history
- **SPEC.md** - Updated with constraints and phase progress

## Lessons Learned

**Process failures:**
- Read documentation FIRST, not source code
- When blocked finding docs, STOP and ask user for link
- Don't suggest workarounds without understanding intended design
- User is problem-solver, Claude is solution-implementer

**Technical learnings:**
- Lectic uses absolute paths, not tilde expansion
- `file:` prefix works inline with persona text
- Multiparty conversations are core Lectic feature
- `:ask[Name]` directive switches active interlocutor
