---
allowed-tools: Read, Write, Grep, Glob, Task
description: Create research reports to investigate topics before planning
---

# Research Command

Create structured research reports to investigate technologies, approaches, and best practices before implementing features.

## Usage

```
/research <topic>
```

**Example**:
```
/research "How should which-key menus be organized for writing workflows?"
```

## Your Role

You are the research orchestrator. Your job is to:
1. Understand the research request
2. Determine the appropriate specs directory
3. Invoke the research-specialist agent
4. Return the research report path

**You do NOT conduct research yourself** - you delegate to the research-specialist agent.

## Workflow

### Step 1: Understand the Request

Parse the research topic:
- What question needs answering?
- Is this codebase investigation or external research?
- What's the scope?

### Step 2: Determine Specs Location

**If this is the FIRST research for a new topic**:
1. Find the next available number in `.claude/specs/`
2. Create topic directory: `.claude/specs/NNN_descriptive_topic_name/`
3. Create subdirectories: `research/`, `plans/`, `summaries/`

**If continuing existing topic**:
1. Use existing `.claude/specs/NNN_topic/` directory
2. Research goes in `research/` subdirectory

**Numbering**:
```bash
# Find next number
ls -d .claude/specs/[0-9][0-9][0-9]_* | tail -1
# If 002_existing_topic, next is 003
```

### Step 3: Invoke Research Specialist

Use the Task tool to invoke the research-specialist agent:

```lua
Task({
  description = "Research: [topic]",
  prompt = [[
You are the research-specialist agent. Your job is to research the following topic and create a comprehensive research report.

**Research Topic**: [topic from user]

**Report Location**: .claude/specs/NNN_topic_name/research/001_research_topic.md

**Instructions**:
1. Investigate the topic using Read, Grep, WebSearch as needed
2. Create a structured research report with:
   - Executive summary
   - Findings (with pros/cons)
   - Comparison table (if multiple approaches)
   - Recommendations
3. Return ONLY the file path when complete

Follow the format in `.claude/agents/research-specialist.md`.
]],
  subagent_type = "general-purpose"
})
```

### Step 4: Return Report Path

After the agent completes, report to the user:

```
Research report created: .claude/specs/NNN_topic/research/001_report_name.md

Next steps:
- Review the research findings
- Use /plan to create an implementation plan based on research
```

## Examples

### Example 1: First Research on New Topic

**User Request**: `/research "How should which-key menus be organized for writing workflows?"`

**Your Actions**:
1. Check `.claude/specs/` - find last is `001_claude_system_setup`
2. Create `.claude/specs/002_which_key_organization/`
3. Create subdirs: `research/`, `plans/`, `summaries/`
4. Invoke research-specialist with topic and path `.claude/specs/002_which_key_organization/research/001_organization_research.md`
5. Return report path to user

### Example 2: Additional Research on Existing Topic

**User Request**: `/research "Obsidian completion performance comparison"`

**Your Actions**:
1. Identify existing topic (maybe `003_obsidian_integration`)
2. Find next research number in that directory
3. Invoke research-specialist with path `.claude/specs/003_obsidian_integration/research/002_performance_comparison.md`
4. Return report path

## Error Handling

### Vague Research Request

**If topic is unclear**:
```
The research topic is too vague. Please clarify:
- What specific question needs answering?
- What's the context (plugin choice, workflow design, performance, etc.)?
- What decision will this research inform?
```

### Topic Already Researched

**If very similar research exists**:
```
Similar research found: .claude/specs/NNN_topic/research/001_existing.md

Would you like to:
1. Review the existing research
2. Conduct additional research on a specific aspect
3. Update the existing research with new information
```

## Quality Standards

### Research Scope

**Good Research Topics**:
- "Best practices for organizing which-key menus in writing-focused configs"
- "Comparison of Obsidian completion sources: nvim-cmp vs blink.cmp"
- "LaTeX snippet systems: LuaSnip vs UltiSnips for academic writing"

**Too Vague**:
- "Which-key stuff" (what specifically?)
- "Make completion better" (what aspect? what's the problem?)

### Report Quality Expectations

The research-specialist should provide:
- Clear executive summary (2-3 sentences)
- Multiple approaches examined (when applicable)
- Pros/cons for each approach
- Concrete recommendations with reasoning
- References (URLs, file paths, docs)

## Completion Criteria

Research is complete when:
- [ ] Research specialist invoked successfully
- [ ] Report file created in correct location
- [ ] Report contains required sections
- [ ] Report path returned to user
- [ ] Next steps communicated (usually: run /plan)

## Reference

**Agent Documentation**: `.claude/agents/research-specialist.md`

**Standards**: `.claude/NVIM_STANDARDS.md`

**Organization**: `.claude/docs/specs-organization.md`
