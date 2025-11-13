# Methods + Tools Library - Implementation Plan

**Created**: 2025-11-11
**Status**: Phase 1 - In Progress
**Approach**: Iterative - scaffold structure first, refine content as we build

---

## Progress Log

### 2025-11-11 - Phase 1 Started
- ✅ Created directory structure at `~/SecondBrain/4-Resources/Methods+Tools/`
- ✅ Created Phase 1 task list at `~/SecondBrain/4-Resources/Methods+Tools/PHASE-1-TASKS.md`
- ⏳ Awaiting Nathan's completion of Task 1.1, 1.2, 1.3 (category definitions, pilot list, template preferences)

---

## Overview

Build a comprehensive library of methods and frameworks in `~/SecondBrain/4-Resources/Methods+Tools/` covering:
- Facilitation Tools
- Coaching & Consulting Frameworks
- Research Methods
- Psychological Frameworks

**Integration**: Once complete, content will be added to the Zettelkasten.

**Obsidian Integration**:
- Tags in frontmatter for filtering/grouping
- Wiki links `[[Entry Name]]` for connections between entries
- Index files as MOCs (Maps of Content) for navigation and progress tracking
- Leverage Obsidian's graph view, backlinks, and search

**Division of Labor**:
- **Claude Code**: Structure, scaffolding, file generation, organization, batch operations
- **Nathan + Lectic**: Content creation, refinement, voice, quality control

---

## Phase 1: Define Structure & Templates

**Goal**: Establish framework categories, field schemas, and content templates before generating files.

### Task 1.1: Define Framework Categories & Field Schemas
**Owner**: Nathan (with Claude Code assistance)
**Deliverable**: Document listing all framework types with their required fields

**Framework Categories**:

1. **Facilitation Tools**
2. **Coaching & Consulting Frameworks**
   - Coaching
   - Leadership + Culture
   - Social Innovation + Design Strategy
3. **Research Methods**
   - Qualitative
   - Hybrid Methods
4. **Psychological Frameworks**

**Universal Fields** (all categories):
- Name
- Origin
- Description
- Details
- How to Use
- Notes
- Sources

**Additional Fields for Facilitation Tools Only**:
- Number of People
- Timing
- Materials
- Setup

**Action Items**:
- [ ] Nathan: Review framework categories (see PHASE-1-TASKS.md)
- [ ] Nathan: Confirm field list is sufficient to start (see PHASE-1-TASKS.md)
- [ ] Nathan: Note any immediate additions/changes (see PHASE-1-TASKS.md)
- [ ] Claude: Document any refinements

**Status**: ⏳ In Progress - Nathan working on PHASE-1-TASKS.md

---

### Task 1.2: Create Content Templates
**Owner**: Claude Code
**Deliverable**: Markdown templates for each framework type with Lectic frontmatter

**Template Requirements**:
- Lectic frontmatter (Obsidian-compatible)
- Appropriate tags for each category/subcategory
- Suggested persona assignment
- All field sections with brief prompts
- Initial Lectic conversation starter
- Placeholder for context file links
- Section for wiki links to related entries

**Example Template - Facilitation Tools**:
```markdown
---
id:
aliases: []
tags: [facilitation-tools]
interlocutor:
  name: Designer
  prompt: You are an expert workshop designer and facilitator...
---

# [Tool Name]

## Context Files
[Add relevant context files here using <leader>mc]

## Origin
[Where did this come from? Who created it?]

## Description
[What is this tool? What's its purpose?]

## Details
[Key concepts, variations, important nuances]

## Number of People
[Range or specific number]

## Timing
[Duration/time required]

## Materials
[What's needed to run this]

## Setup
[How to prepare]

## How to Use
[Step-by-step process]

## Notes
[Tips, variations, watch-outs]

## Sources
[Links, books, references]

## Related
[Wiki links to related tools, frameworks, case studies]
- [[Related Tool 1]]
- [[Related Framework 1]]

---

[Start your conversation with Lectic here]
```

**Example Template - Coaching/Consulting Frameworks**:
```markdown
---
id:
aliases: []
tags: [coaching-consulting, leadership-culture]
interlocutor:
  name: Consultant
  prompt: You are a business strategy expert...
---

# [Framework Name]

## Context Files
[Add relevant context files here using <leader>mc]

## Origin
[Where did this come from? Who created it?]

## Description
[What is this framework? What's its purpose?]

## Details
[Key concepts, components, important nuances]

## How to Use
[When to use it, how to apply it, process]

## Notes
[Tips, variations, watch-outs, examples]

## Sources
[Links, books, references]

## Related
[Wiki links to related frameworks, tools, case studies]
- [[Related Framework 1]]
- [[Related Tool 1]]

---

[Start your conversation with Lectic here]
```

**Action Items**:
- [ ] Claude: Create template for Facilitation Tools (waiting for Nathan's Task 1.3 preferences)
- [ ] Claude: Create template for Coaching & Consulting Frameworks (waiting for Nathan's Task 1.3 preferences)
- [ ] Claude: Create template for Research Methods (waiting for Nathan's Task 1.3 preferences)
- [ ] Claude: Create template for Psychological Frameworks (waiting for Nathan's Task 1.3 preferences)
- [ ] Nathan: Review templates and refine as needed

**Status**: ⏳ Pending - Awaiting Nathan's template preferences from PHASE-1-TASKS.md

---

### Task 1.3: Define Directory Structure
**Owner**: Nathan (with Claude Code input)
**Deliverable**: Finalized directory organization system

**Directory Structure**:
```
~/SecondBrain/4-Resources/Methods+Tools/
├── Facilitation-Tools/
│   ├── _Index.md
│   └── [subcategories TBD by Nathan]
├── Coaching-Consulting-Frameworks/
│   ├── _Index.md
│   ├── Coaching/
│   ├── Leadership-Culture/
│   └── Social-Innovation-Design-Strategy/
├── Research-Methods/
│   ├── _Index.md
│   ├── Qualitative/
│   └── Hybrid/
├── Psychological-Frameworks/
│   ├── _Index.md
│   └── [subcategories TBD by Nathan]
├── _Templates/
│   ├── facilitation-tool-template.md
│   ├── coaching-consulting-framework-template.md
│   ├── research-method-template.md
│   └── psychological-framework-template.md
└── _Master-Index.md
```

**Index Files Purpose**:
- Category-level `_Index.md` files serve as MOCs for each framework type
- `_Master-Index.md` provides overview of entire library
- Track completion status
- Curated navigation alongside Obsidian's native features

**Action Items**:
- [ ] Nathan: Define subcategories for Facilitation Tools (if needed) - see PHASE-1-TASKS.md
- [ ] Nathan: Define subcategories for Psychological Frameworks (if needed) - see PHASE-1-TASKS.md
- [x] Nathan: Confirm naming conventions - **Methods+Tools** (no spaces)
- [x] Claude: Create directory structure in `~/SecondBrain/4-Resources/`

**Status**: ✅ Complete - Directory structure created at `~/SecondBrain/4-Resources/Methods+Tools/`

---

## Phase 2: Initial Batch & Pilot

**Goal**: Create small batch of entries to test workflow and refine approach.

### Task 2.1: List Initial Batch of Tools/Frameworks
**Owner**: Nathan
**Deliverable**: Curated list of 10-15 entries across different categories for pilot

**Suggested Pilot Batch**:
- 5 Facilitation Tools (e.g., Dot Voting, 1-2-4-All, Check-In, LEGO Serious Play, World Café)
- 3 Coaching/Consulting Frameworks (e.g., Co-Active Coaching, GROW Model, Matrix of Wise Compassion)
- 3 Research Methods (e.g., Dialogue Interviews, Ethnographic Notetaking, Organizational Anthropology)
- 2 Psychological Frameworks (e.g., IFS, Gestalt)

**Action Items**:
- [ ] Nathan: Create list of 10-15 pilot entries
- [ ] Nathan: Assign category and subcategory to each
- [ ] Nathan: Assign suggested Lectic persona for each entry
- [ ] Nathan: Note any existing resources/context files

---

### Task 2.2: Generate Pilot Files
**Owner**: Claude Code
**Deliverable**: 10-15 markdown files with templates and frontmatter

**Generation Specifications**:
- Use appropriate template for each framework type
- Populate frontmatter with correct persona and tags
- Create filename from entry name (kebab-case)
- Place in correct subdirectory
- Keep it simple - just template structure, no pre-filled content

**Action Items**:
- [ ] Claude: Generate all pilot files based on Nathan's list
- [ ] Claude: Create initial index files with pilot entries
- [ ] Claude: Verify all files have correct structure
- [ ] Nathan: Spot-check generated files

---

### Task 2.3: Content Creation - Pilot Entries
**Owner**: Nathan + Lectic
**Deliverable**: 2-3 fully completed entries as quality examples

**Workflow**:
1. Open file in nvim
2. Add context files with `<leader>mc` if available
3. Switch persona if needed with `<leader>mp`
4. Work with Lectic to populate all sections
5. Add wiki links to related entries as they're created
6. Refine and polish until satisfied
7. Move to next entry

**Action Items**:
- [ ] Nathan: Complete 2-3 entries to establish quality bar
- [ ] Nathan: Note any template improvements needed
- [ ] Nathan: Document any workflow refinements
- [ ] Nathan: Confirm field structure works before scaling

---

### Task 2.4: Quality Review & Template Refinement
**Owner**: Nathan + Claude Code
**Deliverable**: Refined templates based on pilot learnings

**Review Questions**:
- Are the fields working? Any missing? Any unnecessary?
- Is the Lectic persona assignment appropriate?
- Does the template structure facilitate good conversations?
- Is the directory organization working?
- Are index files useful for navigation?
- Is the tagging strategy working?
- Are wiki links emerging naturally?
- Any workflow improvements needed?

**Action Items**:
- [ ] Nathan: Review completed pilot entries
- [ ] Nathan: List any template/field changes
- [ ] Nathan: Confirm we're ready to scale
- [ ] Claude: Update templates based on feedback
- [ ] Both: Agree on refined approach for full library

---

## Phase 3: Full Library Build

**Goal**: Generate complete set of framework files and establish content production rhythm.

### Task 3.1: Comprehensive Framework List
**Owner**: Nathan
**Deliverable**: Expanded list of all frameworks to document

**List Requirements**:
- Framework name
- Category and subcategory
- Suggested Lectic persona
- Priority (high/medium/low) if desired
- Any existing context files to reference

**Action Items**:
- [ ] Nathan: Expand initial batch to comprehensive list
- [ ] Nathan: Can be grown over time - doesn't need to be exhaustive immediately
- [ ] Nathan: Categorize and prioritize
- [ ] Claude: Review for any structural considerations

---

### Task 3.2: Batch File Generation
**Owner**: Claude Code
**Deliverable**: All framework files generated with templates

**Batch Specifications**:
- Generate files based on Nathan's list
- Use refined templates from Phase 2
- Consistent naming and structure
- Proper tags in frontmatter
- Update index files with all new entries

**Action Items**:
- [ ] Claude: Generate all files from comprehensive list
- [ ] Claude: Update category index files with new entries
- [ ] Claude: Update master index
- [ ] Nathan: Verify file structure

---

### Task 3.3: Content Production System
**Owner**: Nathan + Lectic
**Deliverable**: Completed framework entries (ongoing)

**Production Strategy**:
- Work through systematically or as needed
- Can batch by category/persona if desired
- Use completed entries as context for related frameworks
- Add wiki links between related entries as connections emerge
- Update index files as entries are completed
- Organic approach - no rigid schedule unless Nathan wants one

**Action Items**:
- [ ] Nathan: Work through frameworks at own pace
- [ ] Nathan: Add wiki links between related entries
- [ ] Nathan: Add new frameworks to list as discovered
- [ ] Nathan: Note any new template needs that emerge
- [ ] Claude: Support with structural changes as needed
- [ ] Claude: Update index files as needed

---

## Phase 4: Zettelkasten Integration

**Goal**: Integrate completed Methods + Tools Library into existing Zettelkasten system.

### Task 4.1: Integration Planning
**Owner**: Nathan + Claude Code
**Deliverable**: Strategy for how library content integrates with Zettelkasten

**Considerations**:
- Should entries be copied or moved?
- How to maintain bidirectional links?
- Tagging strategy for discoverability
- Index/MOC approach across systems
- Preservation of library organization

**Action Items**:
- [ ] Nathan: Decide integration approach
- [ ] Nathan: Define how library relates to existing Zettelkasten structure
- [ ] Claude: Document integration strategy
- [ ] Both: Agree on implementation plan

---

### Task 4.2: Integration Implementation
**Owner**: Claude Code (with Nathan direction)
**Deliverable**: Library content integrated into Zettelkasten

**Implementation Details**: TBD based on Task 4.1 decisions

**Action Items**:
- [ ] Claude: Execute integration based on agreed strategy
- [ ] Nathan: Verify integration preserves content and structure
- [ ] Nathan: Test navigation and discoverability
- [ ] Nathan: Verify wiki links and backlinks work correctly

---

## Success Metrics

**Methods + Tools Library**:
- [ ] All framework categories defined with working templates
- [ ] Pilot batch completed with quality bar established
- [ ] Sustainable workflow for ongoing content creation
- [ ] Useful as reference for own work and sharing publicly
- [ ] Easy to add new frameworks over time
- [ ] Wiki links create useful connection web
- [ ] Index files serve as effective navigation aids

**Zettelkasten Integration**:
- [ ] Library content discoverable within Zettelkasten
- [ ] Links and references work seamlessly
- [ ] Organization preserved and enhanced
- [ ] Easy to navigate between library and other notes
- [ ] Graph view shows meaningful connections

**System Health**:
- [ ] Templates facilitate good Lectic conversations
- [ ] Persona assignments work well for each category
- [ ] Directory organization stays manageable
- [ ] Tags enable effective filtering and search
- [ ] Valuable as personal knowledge system

---

## Notes & Decisions Log

### Decisions Made
1. **Location**: `~/SecondBrain/3-Resources/Methods + Tools Library/`
2. **Four main categories**: Facilitation Tools, Coaching & Consulting Frameworks, Research Methods, Psychological Frameworks
3. **Coaching/Consulting split into three**: Coaching, Leadership + Culture, Social Innovation + Design Strategy
4. **Research Methods**: Qualitative and Hybrid only (no pure quantitative)
5. **Universal fields**: Name, Origin, Description, Details, How to Use, Notes, Sources
6. **Facilitation-specific fields**: Number of People, Timing, Materials, Setup
7. **Future integration**: Library will be added to Zettelkasten when complete
8. **Obsidian features**: Tags in frontmatter, wiki links for connections, index files as MOCs
9. **Index files**: Keep them for navigation, progress tracking, and curated MOCs

### Initial Decisions Needed
1. Subcategories for Facilitation Tools?
2. Subcategories for Psychological Frameworks?
3. Any other immediate structural preferences?

### To Be Refined As We Build
- Whether to track completion status in frontmatter or just in index files
- How to handle frameworks that span multiple categories
- Cross-linking strategy within library
- Zettelkasten integration approach
- Public sharing approach

---

## Next Steps

1. Nathan reviews this plan
2. Nathan provides initial batch list (10-15 entries) for pilot
3. Nathan confirms any subcategory preferences
4. Claude generates templates
5. Claude creates directory structure
6. Claude generates pilot files
7. Nathan completes 2-3 pilot entries with Lectic
8. Refine templates based on learnings
9. Scale to full library
