# Getting Started with the Claude Code Documentation System

This guide walks you through using the `.claude/` documentation system to plan, implement, and document nvim configuration changes.

## Quick Overview

The system uses a collaborative workflow between you and the main Claude agent:

1. **Session Init** (`/init`): Load context at start of every session
2. **Research** (optional): Use `/research` for deep investigation of unfamiliar topics
3. **Implementation**: Work directly with main agent following SESSION_PROTOCOL.md
4. **Documentation**: Main agent documents work in SESSION_LOG.md as you go

## The Two Commands

### /research

**Purpose**: Investigate topics before planning

**When to use**:
- Comparing multiple approaches (which plugin, which pattern)
- Understanding best practices
- Exploring unfamiliar territory

**Example**:
```
/research "How should which-key menus be organized for writing workflows?"
```

**When to use**:
- Investigating unfamiliar plugins, patterns, or approaches
- Comparing multiple technical solutions
- Understanding best practices before implementation
- Deep-diving into complex topics

**Output**: Creates research report in project directory

**What it does**:
1. Invokes research-specialist agent
2. Agent uses Read/Grep/WebSearch (NO code modification)
3. Creates structured report with findings, pros/cons, recommendations
4. Returns report path

**Note**: Most work happens directly with main agent. Only use `/research` for complex investigations that benefit from focused research agent.

### /init

**Purpose**: Load core context at session start

**When to use**:
- At the beginning of EVERY session
- When resuming work on a project

**Example**:
```
/init
```

**What it does**:
1. Reads three core files:
   - `PROJECT_CONTEXT.md` - Config overview
   - `GLOBAL_SUMMARY_LOG.md` - Project history
   - `SESSION_PROTOCOL.md` - Agent behavior guidelines
2. Confirms what was loaded
3. Asks how to proceed

**Why this matters**: Ensures agent has full context about your config, preferences, and past work.

---

## Normal Workflow (Without Slash Commands)

Most of your work happens in **collaborative mode** with the main agent:

1. **Discuss** - Talk through what you want to build
2. **Plan together** - Agent proposes approach, you approve
3. **Implement incrementally** - Agent codes, you review/test
4. **Document as you go** - Agent updates SESSION_LOG.md after each batch

This is faster and more flexible than using formal slash commands for every task.

---

## Workflow Example

Let's walk through adding a new feature to your which-key search menu.

### Step 1: Discussion

**You**: "I want to add current buffer grep to my <leader>f menu"

**Agent**: "I can add that. Looking at your which-key.lua, I see you already have:
- `<leader>fg` for project grep
- `<leader>fw` for word under cursor

Should I add `<leader>fc` for current buffer grep? What Telescope function would you like - `current_buffer_fuzzy_find`?"

**You**: "Yes, <leader>fc sounds good. Use that function."

### Step 2: Implementation

**Agent**:
1. Creates function in `lua/core/functions.lua`
2. Adds keybinding to `lua/plugins/which-key.lua`
3. Shows you the code for approval
4. You approve
5. Agent makes the changes
6. You test it with `<leader>fc`

### Step 3: Documentation

**Agent** automatically updates `specs/003_zettelkasten_refinement/SESSION_LOG.md`:

```markdown
### Task Batch 1: Add Current Buffer Grep

**Discussion**:
- User wanted to grep within current file only
- Decided on `<leader>fc` keybinding
- Using Telescope's `current_buffer_fuzzy_find()`

**Implementation**:
- Added `SearchCurrentBuffer()` to `lua/core/functions.lua` (lines 23-26)
- Added keybinding to which-key.lua under FIND menu

**Testing**: Verified <leader>fc opens fuzzy finder for current buffer

**Files Modified**:
- `lua/core/functions.lua` - New SearchCurrentBuffer() function
- `lua/plugins/which-key.lua` - Added <leader>fc binding
```

### Step 4: Git Commit (when appropriate)

After completing a logical chunk of work, agent creates a git commit:

```
feat: add current buffer grep to FIND menu

- Add SearchCurrentBuffer() function
- Add <leader>fc keybinding to which-key menu
- Update PLAN.md checkbox

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## When to Use /research

Most work doesn't need `/research`. Use it when:

**Need deep investigation**:
- "What's the best way to integrate Obsidian with Telescope?"
- "How do other people structure zettelkasten workflows in Neovim?"
- "What are the tradeoffs between different completion engines?"

**Don't need it for**:
- Simple additions ("add a keybinding")
- Bug fixes ("this function isn't working")
- Configuration changes ("change this color")

The main agent can handle 95% of your work without invoking specialized agents.

---

## Tips for Effective Collaboration

1. **Start with `/init`** - Always load context at session start
2. **Discuss first** - Talk through what you want before coding
3. **Review code** - Agent shows changes before making them
4. **Test incrementally** - Check each change works before moving on
5. **Use `/research` sparingly** - Only for deep investigations
6. **Keep maintenance log** - Small fixes go in `000_maintenance_debug/MAINTENANCE_LOG.md`
7. **Trust the process** - Agent documents as you go in SESSION_LOG.md
