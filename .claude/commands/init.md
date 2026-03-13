---
allowed-tools: Read
description: Load core context at session start
---

# Init Command

Load the three core context files that provide complete understanding of the Neovim configuration and project state.

## Usage

```
/init
```

Use at the start of every new session to load context.

## What This Command Does

Reads three core files:
1. `.claude/PROJECT_CONTEXT.md` - Config overview, tools used, preferences
2. `.claude/GLOBAL_SUMMARY_LOG.md` - All completed projects history
3. `.claude/SESSION_PROTOCOL.md` - Agent behavior and documentation guidelines

**Token cost**: ~10-15KB (very reasonable for full context)

## Your Task

When this command is invoked:

1. **Read the three core files** (in this order):
   - `.claude/PROJECT_CONTEXT.md`
   - `.claude/GLOBAL_SUMMARY_LOG.md`
   - `.claude/SESSION_PROTOCOL.md`

2. **Confirm what was loaded**:
   ```
   Context loaded:
   - PROJECT_CONTEXT.md - [brief 1-line summary]
   - GLOBAL_SUMMARY_LOG.md - [number of completed projects]
   - SESSION_PROTOCOL.md - [1-line confirmation]

   Hey Nathan! My prime directive is universal verification and accuracy. What do you want to work on?
   ```

3. **Be concise**: User knows what these files contain - just confirm they loaded

## Example Output

```
Context loaded:
- PROJECT_CONTEXT.md - Writing/publishing Neovim config
- GLOBAL_SUMMARY_LOG.md - 3 completed projects
- SESSION_PROTOCOL.md - Behavior guidelines loaded

Hey Nathan! My prime directive is universal verification and accuracy. What do you want to work on?
```

## Important

- **Always read all three files** - no exceptions
- **Keep response short** - don't summarize the entire contents
- **Don't ask questions** - the protocol tells you how to behave
- **Follow SESSION_PROTOCOL.md** - especially the collaborative work style and documentation rules
