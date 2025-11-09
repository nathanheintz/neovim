---
allowed-tools: Read, Write, Grep, Glob, Task
description: Create structured implementation plans with phases and checkboxes
---

# Plan Command

Create detailed, actionable implementation plans that break features into testable phases.

## Usage

```
/plan <feature description>
```

**Example**:
```
/plan "Reorganize which-key menus for writing-focused workflow"
```

## Your Role

You are the planning orchestrator. Your job is to:
1. Understand the feature request
2. Locate any related research
3. Determine the appropriate specs directory
4. Invoke the plan-architect agent
5. Return the plan path

**You do NOT create plans yourself** - you delegate to the plan-architect agent.

## Workflow

### Step 1: Understand the Request

Parse the feature description:
- What is being built?
- What's the scope?
- Are there related research reports?

### Step 2: Check for Research

Look for related research in `.claude/specs/`:
```bash
# Search for research reports that might be relevant
find .claude/specs -name "*.md" -path "*/research/*"
```

If research exists on this topic, note the path to pass to plan-architect.

### Step 3: Determine Specs Location

**If this is the FIRST plan for a new topic**:
1. Find next available number in `.claude/specs/`
2. Create topic directory: `.claude/specs/NNN_descriptive_topic_name/`
3. Create subdirectories: `plans/`, `summaries/` (and `research/` if not exists)

**If continuing existing topic**:
1. Use existing `.claude/specs/NNN_topic/` directory
2. Plan goes in `plans/` subdirectory
3. Number it sequentially (001, 002, etc.)

### Step 4: Invoke Plan Architect

Use the Task tool to invoke the plan-architect agent:

```lua
Task({
  description = "Plan: [feature]",
  prompt = [[
You are the plan-architect agent. Your job is to create a detailed implementation plan for the following feature.

**Feature**: [feature description from user]

**Research Reports** (if any):
- [path to research report 1]
- [path to research report 2]

**Plan Location**: .claude/specs/NNN_topic_name/plans/NNN_plan_name.md

**Instructions**:
1. Read any research reports provided
2. Examine current codebase state with Read/Grep
3. Assess complexity (1-10 scale)
4. Break into 3-6 sequential phases
5. Create plan file with:
   - Metadata (complexity, duration, type)
   - Success criteria
   - Phases with checkbox tasks
   - Testing requirements
   - Technical approach
6. Return ONLY: plan path, phase count, complexity, estimated duration

Follow the format in `.claude/agents/plan-architect.md`.

Reference `.claude/NVIM_STANDARDS.md` for coding conventions.
]],
  subagent_type = "general-purpose"
})
```

### Step 5: Return Plan Summary

After the agent completes, report to the user:

```
Implementation plan created: .claude/specs/NNN_topic/plans/001_plan_name.md

Phases: N
Complexity: X/10 (Medium)
Estimated duration: Y hours

Next steps:
- Review the plan for accuracy
- Use /implement to execute the plan
```

## Examples

### Example 1: Plan After Research

**User Request**: `/plan "Reorganize which-key menus based on research findings"`

**Your Actions**:
1. Check for research in `.claude/specs/002_which_key_organization/research/`
2. Find: `001_organization_research.md`
3. Use existing `002_which_key_organization/` directory
4. Invoke plan-architect with:
   - Feature description
   - Research report path
   - Plan location: `.claude/specs/002_which_key_organization/plans/001_reorganize_menus.md`
5. Return plan summary to user

### Example 2: Plan Without Research

**User Request**: `/plan "Auto-load Obsidian for markdown files"`

**Your Actions**:
1. Check for research - none found
2. Create `.claude/specs/003_obsidian_autoload/`
3. Invoke plan-architect with:
   - Feature description
   - No research reports
   - Plan location: `.claude/specs/003_obsidian_autoload/plans/001_autoload_obsidian.md`
4. Return plan summary

### Example 3: Revised Plan

**User Request**: `/plan "Add additional writing commands to which-key (revised)"`

**Your Actions**:
1. Find existing topic: `.claude/specs/002_which_key_organization/`
2. Check existing plans: `001_reorganize_menus.md` exists
3. Create new plan: `002_additional_writing_commands.md`
4. Invoke plan-architect
5. Return plan summary

## Error Handling

### Vague Feature Request

**If feature is unclear**:
```
The feature description is too vague. Please clarify:
- What specific functionality is being added/changed?
- What files/plugins are affected?
- What's the user-facing behavior?
- What problem does this solve?
```

### Recommend Research First

**If planning reveals unknowns**:
```
This feature requires research first. Unknowns include:
- [unknown 1]
- [unknown 2]

Recommend: /research "[specific research topic]"
```

### Plan Already Exists

**If very similar plan exists**:
```
Similar plan found: .claude/specs/NNN_topic/plans/001_existing.md

Would you like to:
1. Review the existing plan
2. Create a revised plan (will be numbered 002)
3. Update the existing plan with new requirements
```

## Quality Standards

### Feature Descriptions

**Good Feature Descriptions**:
- "Reorganize which-key menus to group writing commands under <leader>w"
- "Add Obsidian auto-loading when opening markdown files in SecondBrain vault"
- "Create Lectic persona system with frontmatter templates"

**Too Vague**:
- "Fix which-key" (what's broken? what should it do?)
- "Add Obsidian" (what specific integration? what behavior?)

### Plan Quality Expectations

The plan-architect should provide:
- 3-6 phases (not too granular, not too coarse)
- Checkbox tasks for each phase
- Testing requirements per phase
- Complexity assessment (1-10)
- Realistic time estimates
- Technical approach with rationale

## Completion Criteria

Planning is complete when:
- [ ] Plan architect invoked successfully
- [ ] Plan file created in correct location
- [ ] Plan contains all required sections
- [ ] Phases are sequential and testable
- [ ] Plan metadata returned to user
- [ ] Next steps communicated (usually: run /implement)

## Reference

**Agent Documentation**: `.claude/agents/plan-architect.md`

**Standards**: `.claude/NVIM_STANDARDS.md`

**Organization**: `.claude/docs/specs-organization.md`
