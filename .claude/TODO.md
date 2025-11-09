# TODO: Nvim Configuration Development

## High Priority

### Which-Key Menu Reorganization
- Research: Best practices for organizing which-key menus in writing-focused configs
- Plan: Reorganize menus around workflows (writing, git, navigation, etc.)
- Implement: New menu structure
- Document: Create CHEATSHEET.md with actual keybindings

**Notes**:
- Remove unused keybindings from Ben's config (Python, NixOS, etc.)
- Focus on writing workflow (<leader>w), Lectic (<leader>m?), Obsidian
- Integrate keybindings from other cheatsheets I have

### Obsidian Auto-loading
- Plan: Configure Obsidian to auto-load for markdown files in SecondBrain vault
- Current: Manual loading via `:Lazy load obsidian`

### Lectic Personas System
- Research: How other users manage Lectic personas/templates
- Plan: Frontmatter template system for different writing contexts
- Implement: Commands to switch personas easily

## Medium Priority

### Dashboard Customization
- Update dashboard shortcuts to match reorganized which-key menus
- Fix neo-tree reference (currently still says NvimTreeToggle)

### Ghost Theme Development Workflow
- Plan: Keybindings and workflow for Ghost theme development
- HTML/Handlebars-specific tooling

### LaTeX Workflow Refinement
- Keep VimTeX but streamline commands
- Integrate with writing workflow

## Low Priority

### Plugin Cleanup
- Remove unused plugins from Ben's config
- Audit what's actually needed for writing/publishing workflow

### Performance Optimization
- Review lazy loading configuration
- Startup time benchmarking

## Documentation

### CHEATSHEET.md
**Status**: Not yet created - waiting for which-key reorganization

**When creating**:
- Document only CURRENT keybindings (not Ben's old ones)
- Integrate keybindings from my other cheatsheet files
- Focus on writing workflow, Lectic, Obsidian, LaTeX
- Include special workflows (zen mode, Lectic, Obsidian linking)

**Other cheatsheets to integrate**:
- [List my other cheatsheet files here when ready]

### README.md
**Status**: Created with basic structure

**Future updates** (via /document after implementations):
- Add new features as they're implemented
- Update plugin list when plugins change
- Keep synchronized with actual config

## Research Topics

Ideas for future research:
- Markdown presentation systems (Deckset, Marp) - integration approaches
- Literature vault workflow (Readwise → Obsidian)
- Lectic memory management strategies
- Ghost theme development best practices in nvim

## Notes

- Use `/research`, `/plan`, `/implement`, `/document` workflow for all items
- Update this TODO as priorities shift
- Archive completed items by moving to implementation summaries
