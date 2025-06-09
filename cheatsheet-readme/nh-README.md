---
interlocutor:
  # Required fields
  name: Homie
  prompt: You are an expert logician, philosopher, political theorist, neuroscientist, psychotherapist, psychonaut and pedagogist. You are here to help me as a writing tutor to create accessible and helpful nonfiction about internal arts practice (meditation, taiji, qigong), personal development, leadership, productivity, politics and philosophy. 

  # Optional model configuration
  provider: anthropic           # Optional, default anthropic
  # model: claude-3-7-sonnet    # Model selection
  # temperature: 0.7            # Response variability (0-1)
  # max_tokens: 1024            # Maximum response length

  # Optional Context management
  memories: ~/.config/nvim/        # Context from previous conversations.
                                # Added to system prompt.
                                # Can be string or file path

  # # Tool integration
  # tools:
  #   # Command execution tool
  #   exec: python3           # Command to execute
  #   usage: Before running any code, show the code snippet to the user.
  #   name: python            # Optional custom name
---

<!-- Instructions: Write your prompt below, then use <leader>mr to submit it,
or select text and use <leader>ms to submit just that selection. -->


I'm building a second brain zettelkasten in neovim and obsidian. 

In Neovim, I'm using the Lazy plugin manager. 

# Neovim Configuration Description

## Overview
This Neovim setup is a customized fork of the "neotex" configuration originally created by Ben Brast McKie (https://github.com/benbrastmckie/.config/tree/master/nvim) for academic philosophy writing and LaTeX typesetting. The setup has been adapted for MacOS (originally Linux-based) and modified to focus on book writing, self-publishing, and blog theme development.

## Core Features
- Writing-focused environment with markdown and LaTeX support
- AI assistance integration (Lectic and Avante plugins)
- Zettelkasten/Second Brain functionality with Obsidian plug in
- Ghost.org blog theme development support
- Modern plugin management using Lazy.nvim

## Key Plugins
### Plugin Management
Lazy plugin manager via Lazy.lua

### Writing & Documentation
- vimtex: LaTeX support and compilation
- markdown-preview: Real-time markdown preview
- autolist: Smart list management
- luasnip: Snippet engine
- local-highlight: Word highlighting
- Comment.nvim: Smart commenting
- mini.nvim: Collection of minimal plugins
- surround.nvim: Quote/bracket management
- obsidian.nvim: Obsidian note linking and vault support

### AI & Intelligence
- lectic: AI writing assistance
- avante: Advanced AI integration

### Navigation & Interface
- telescope: Fuzzy finder and search
- nvim-tree: File explorer
- which-key: Command helper
- lualine: Status line
- bufferline: Buffer management
- nvim-web-devicons: File icons

### Development
- treesitter: Advanced syntax highlighting
- LSP configuration: Language server support
- mason: LSP package management
- none-ls: Additional LSP features
- nvim-cmp: Completion engine

### Version Control
- gitsigns: Git integration
- lazygit: Git integration

### Utility
- toggleterm: Terminal integration
- sessions: Session management
- autopairs: Auto-closing brackets
- yanky: Advanced yank/paste

## Plugin Optimization Recommendations

### Consider Removing/Disabling:
1. firenvim: Unless you need browser integration
2. lean: If not doing mathematical proofs
3. gh_dashboard: If not actively using GitHub
4. Some mini.nvim modules if unused

### Keep Essential for Your Use Case:
1. All writing-related plugins (vimtex, markdown-preview)
2. AI assistance plugins (lectic, avante)
3. Core navigation tools (telescope, nvim-tree)
4. LSP setup for Ghost theme development
5. Version control tools for collaboration

## Setup Purpose
This configuration serves as a powerful writing and publishing environment, with additional capabilities for web development. The focus is on creating a seamless workflow for book writing, typesetting, and blog management, while maintaining the ability to handle code when needed for ebook formatting and theme customization.

## .config Folder Structure 

```
~/.config/nvim/
├── init.lua                 # Main configuration entry point
├── lua/
│   └── neotex/             # Main configuration directory
│       ├── core/           # Core settings and functions
│       │   ├── options.lua
│       │   ├── keymaps.lua
│       │   └── functions.lua
│       └── plugins/        # Plugin configurations
│           ├── init.lua    # Plugin list and lazy.nvim setup
│           ├── lsp/        # Language server configurations
│           └── ai/         # AI-related plugin configs
├── snippets/               # Custom snippets
└── cheatsheet-readme/      # Documentation and references
```

# My Neovim Stack 

The API Goes Into Fish

Claude 3.5 is more constrained than 3.7 and uses less tokens

Lectic is the md generator

Avante is your chat friend

Both Lectic and Avante are linked to your "Pay as you go" API tokens account on Anthropic

Lazy is your plugin manager

Kitty is your terminal emulator

Fish is your terminal shell within kitty - behavior and text

Claude Code is a standalone solution also linked to Anthropic API

LazyGit I guess is Lazy's built in git plugin but not sure how that works

In terminal you can type git init
