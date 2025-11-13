# Case Studies Portfolio - Implementation Plan

**Created**: 2025-11-11
**Status**: Planning
**Approach**: Convert Notion consulting portfolio to polished website case studies

---

## Overview

Transform existing Notion consulting portfolio into publication-ready case studies for nathanheintz.com.

**Source**: Notion portfolio (exported as markdown)
**Destination**: Ghost CMS on nathanheintz.com
**Integration**: Link to Methods + Tools Library, tag appropriately

**Division of Labor**:
- **Claude Code**: File conversion, formatting, batch operations, Ghost preparation
- **Nathan + Lectic**: Content refinement, narrative polish, editorial decisions

---

## Phase 1: Export & Analysis

**Goal**: Get Notion content out and understand what we're working with.

### Task 1.1: Export Notion Portfolio
**Owner**: Nathan
**Deliverable**: Notion portfolio exported as markdown files

**Export Process**:
- Export from Notion as Markdown & CSV
- Include all embedded images/assets
- Preserve existing structure

**Action Items**:
- [ ] Nathan: Export Notion portfolio to markdown
- [ ] Nathan: Save export to temporary working directory
- [ ] Nathan: Note export location for Claude

---

### Task 1.2: Analyze Portfolio Structure
**Owner**: Claude Code + Nathan
**Deliverable**: Assessment of current portfolio content and structure

**Analysis Questions**:
- How many portfolio entries exist?
- What's the current structure/organization?
- What content exists in each entry?
- What's the quality of markdown export?
- Are images/assets intact?
- Any problematic formatting to address?
- What metadata exists (dates, client names, etc.)?

**Action Items**:
- [ ] Claude: Review exported markdown files
- [ ] Claude: Document current structure and content inventory
- [ ] Claude: Note any format/conversion issues
- [ ] Nathan: Review analysis
- [ ] Both: Identify any cleanup needed before conversion

---

## Phase 2: Case Study Selection & Template Design

**Goal**: Choose which portfolio entries become case studies and define their structure.

### Task 2.1: Select Case Studies
**Owner**: Nathan
**Deliverable**: Curated list of portfolio entries to convert to case studies

**Selection Criteria** (Nathan to define):
- Showcase different types of work
- Strong outcomes/impact
- Good storytelling potential
- Client permission to publish
- Represents current capabilities

**Action Items**:
- [ ] Nathan: Review portfolio entries
- [ ] Nathan: Select entries for case study conversion
- [ ] Nathan: Prioritize order (which to work on first)
- [ ] Nathan: Note any missing information to fill in

---

### Task 2.2: Design Case Study Template
**Owner**: Nathan + Claude Code
**Deliverable**: Standardized case study structure for consistency

**Template Sections** (to be refined by Nathan):
- Title/Project Name
- Client/Organization (if publishable)
- Context/Challenge
- Approach/Methodology
- Process/Timeline
- Methods & Frameworks Used (link to library)
- Outcomes/Impact
- Key Learnings
- Images/Visuals
- Tags/Categories

**Frontmatter Requirements**:
- Ghost-compatible metadata
- Publication date
- Featured image
- Tags
- Custom excerpt
- Any Ghost-specific fields

**Action Items**:
- [ ] Nathan: Define case study sections and structure
- [ ] Nathan: Decide what metadata to include
- [ ] Claude: Create markdown template
- [ ] Claude: Create Ghost-ready template variant
- [ ] Nathan: Review and refine templates

---

## Phase 3: Content Development

**Goal**: Transform selected portfolio entries into polished case studies.

### Task 3.1: Convert Portfolio Entries to Case Study Format
**Owner**: Claude Code
**Deliverable**: Portfolio entries restructured using case study template

**Conversion Process**:
- Import Notion markdown content
- Map to case study template structure
- Preserve images/assets with proper paths
- Add placeholder sections for missing content
- Create working files in Second Brain

**Action Items**:
- [ ] Claude: Convert selected entries to case study template
- [ ] Claude: Organize in `~/SecondBrain/` (location TBD by Nathan)
- [ ] Claude: Preserve all media assets
- [ ] Claude: Note any missing content sections
- [ ] Nathan: Review converted files

---

### Task 3.2: Content Expansion & Refinement
**Owner**: Nathan + Lectic (Writer/Editor personas)
**Deliverable**: Case studies with complete, polished content

**Workflow**:
1. Open case study in nvim
2. Add relevant context files with `<leader>mc`
3. Switch to Writer persona (`<leader>mpw`)
4. Work with Lectic to:
   - Fill in missing sections
   - Improve narrative flow
   - Strengthen storytelling
   - Clarify outcomes/impact
5. Switch to Editor persona (`<leader>mpe`)
6. Refine structure and polish
7. Repeat until publication-ready

**Action Items**:
- [ ] Nathan: Work through each case study with Lectic
- [ ] Nathan: Fill in all content sections
- [ ] Nathan: Ensure consistent voice and quality
- [ ] Nathan: Get any needed client approvals
- [ ] Nathan: Mark case studies as "ready for formatting"

---

### Task 3.3: Link to Methods + Tools Library
**Owner**: Nathan + Claude Code
**Deliverable**: Case studies cross-linked to relevant frameworks

**Linking Strategy**:
- Add "Methods & Frameworks Used" section
- Wiki link to relevant library entries: `[[Framework Name]]`
- Add case study links back to framework entries
- Use consistent linking format

**Action Items**:
- [ ] Nathan: Identify which frameworks were used in each case study
- [ ] Nathan: Add wiki links to framework entries
- [ ] Claude: Add case study examples to framework entries (backlinks)
- [ ] Nathan: Verify bidirectional links work in Obsidian

---

## Phase 4: Ghost Formatting & Preparation

**Goal**: Format case studies for Ghost CMS publication.

### Task 4.1: Image Optimization & Placement
**Owner**: Claude Code + Nathan
**Deliverable**: Images optimized and positioned for web publication

**Image Requirements**:
- Optimize file sizes for web
- Create featured images for each case study
- Position inline images effectively
- Add alt text for accessibility
- Ensure proper image paths for Ghost

**Action Items**:
- [ ] Nathan: Select featured image for each case study
- [ ] Claude: Optimize image file sizes
- [ ] Claude: Convert image paths for Ghost format
- [ ] Nathan: Review image placement and quality
- [ ] Nathan: Write alt text for all images

---

### Task 4.2: Format for Ghost CMS
**Owner**: Claude Code
**Deliverable**: Case studies in Ghost-compatible markdown format

**Ghost Formatting Requirements**:
- Convert wiki links to appropriate format
- Add Ghost-specific frontmatter
- Format images using Ghost syntax
- Set up featured images
- Configure excerpts
- Add tags and metadata
- Format any special content blocks

**Action Items**:
- [ ] Claude: Convert case studies to Ghost markdown format
- [ ] Claude: Add Ghost-specific metadata
- [ ] Claude: Format images for Ghost
- [ ] Claude: Create separate Ghost-ready versions
- [ ] Nathan: Review Ghost-formatted files

---

## Phase 5: Publication

**Goal**: Publish case studies to nathanheintz.com.

### Task 5.1: Create Ghost Blog Posts
**Owner**: Nathan (with Claude Code support)
**Deliverable**: Case studies published as Ghost posts

**Publication Process**:
- Import markdown to Ghost
- Upload images to Ghost
- Configure post settings (tags, featured image, excerpt, etc.)
- Set publication dates
- Configure URLs/slugs
- Save as drafts initially

**Action Items**:
- [ ] Nathan: Import case studies to Ghost
- [ ] Nathan: Upload and configure images
- [ ] Nathan: Set metadata and settings
- [ ] Nathan: Configure tags and categories
- [ ] Nathan: Review in Ghost preview
- [ ] Nathan: Save as drafts for testing

---

### Task 5.2: Tagging & Categorization
**Owner**: Nathan
**Deliverable**: Consistent tagging system for case studies

**Tagging Strategy** (to be defined):
- Project type tags (e.g., workshop design, coaching, research)
- Industry/sector tags
- Methodology tags (link to frameworks)
- Any other relevant categories

**Action Items**:
- [ ] Nathan: Define tagging taxonomy
- [ ] Nathan: Apply tags to all case studies
- [ ] Nathan: Create tag pages if needed
- [ ] Nathan: Ensure tags align with site navigation

---

### Task 5.3: Internal Linking Strategy
**Owner**: Nathan + Claude Code
**Deliverable**: Case studies linked to Methods + Tools Library on website

**Linking Considerations**:
- How to link from Ghost posts to library entries?
- Will library be published on Ghost or separate?
- URL structure for framework entries
- Maintaining bidirectional links

**Action Items**:
- [ ] Nathan: Decide how library will be published
- [ ] Nathan: Define URL structure for framework entries
- [ ] Claude: Update case study links to match publication URLs
- [ ] Nathan: Test all links work correctly

---

## Phase 6: Testing & Quality Assurance

**Goal**: Ensure case studies look great and work properly on the live site.

### Task 6.1: Preview & Review
**Owner**: Nathan
**Deliverable**: Case studies reviewed in Ghost preview mode

**Review Checklist**:
- [ ] Content displays correctly
- [ ] Images load and look good
- [ ] Formatting is clean
- [ ] Links work (internal and external)
- [ ] Mobile view looks good
- [ ] Featured images appear correctly
- [ ] Excerpts are compelling
- [ ] Tags are correct
- [ ] No typos or formatting errors

**Action Items**:
- [ ] Nathan: Review each case study in Ghost preview
- [ ] Nathan: Test on desktop and mobile
- [ ] Nathan: Make any final edits
- [ ] Nathan: Get second opinion if desired

---

### Task 6.2: Cross-Browser & Device Testing
**Owner**: Nathan
**Deliverable**: Case studies verified across devices/browsers

**Testing Matrix**:
- Desktop: Chrome, Firefox, Safari
- Mobile: iOS Safari, Android Chrome
- Tablet view
- Different screen sizes

**Action Items**:
- [ ] Nathan: Test case studies on multiple browsers
- [ ] Nathan: Test on mobile devices
- [ ] Nathan: Verify images and layout work everywhere
- [ ] Nathan: Note any issues for fixing

---

### Task 6.3: Final Polish & Publication
**Owner**: Nathan
**Deliverable**: Case studies published live on nathanheintz.com

**Pre-Publication Checklist**:
- [ ] All content complete and polished
- [ ] Images optimized and positioned
- [ ] Links tested and working
- [ ] Tags and metadata configured
- [ ] SEO considerations addressed
- [ ] Preview looks good on all devices
- [ ] Ready for public viewing

**Action Items**:
- [ ] Nathan: Make any final adjustments
- [ ] Nathan: Set publication dates
- [ ] Nathan: Publish case studies (or schedule)
- [ ] Nathan: Verify live URLs work
- [ ] Nathan: Share/announce if desired

---

## Success Metrics

**Case Studies Quality**:
- [ ] Compelling narratives that showcase work
- [ ] Professional presentation
- [ ] Clear outcomes and impact
- [ ] Consistent structure across all case studies
- [ ] Strong visual presentation

**Technical Quality**:
- [ ] All images load correctly
- [ ] Links work (internal and external)
- [ ] Mobile-responsive and looks good
- [ ] Fast page load times
- [ ] SEO-friendly

**Integration**:
- [ ] Cross-linked to Methods + Tools Library
- [ ] Consistent tagging
- [ ] Easy to navigate between case studies
- [ ] Showcases range of work

**System Health**:
- [ ] Sustainable workflow for adding new case studies
- [ ] Easy to update existing case studies
- [ ] Template works for future projects
- [ ] Valuable for attracting clients/opportunities

---

## Notes & Decisions Log

### Decisions Needed
1. Where to store case study working files in Second Brain?
2. How will Methods + Tools Library be published? (Ghost vs. separate)
3. URL structure for case studies and framework entries
4. Tagging taxonomy
5. How many case studies to start with?
6. Publication schedule (all at once or staggered?)

### To Be Determined
- Client approval process for publishing
- Whether to anonymize any case studies
- How detailed to make each case study
- Target length/depth
- Whether to include testimonials/quotes
- Integration with other site sections

---

## Next Steps

1. Nathan reviews this plan
2. Nathan exports Notion portfolio to markdown
3. Claude analyzes exported content
4. Nathan selects case studies to convert
5. Nathan defines case study template structure
6. Claude converts portfolio entries to template
7. Nathan works with Lectic to polish content
8. Format for Ghost and publish
