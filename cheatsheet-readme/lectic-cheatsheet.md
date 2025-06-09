# Neovim Keybindings Cheatsheet

## Moving Around

## Selecting Text

## Opening and Navigating Files

Open Explorer
Moving within explorer



## Buffers

## Lectic Commands

### Basic Commands
- `:Lectic` - Process current buffer with Lectic AI (supports visual selections)
- `<leader>mr` - Submit entire file to Lectic
- `<leader>ms` - Submit selected text to Lectic

### File Management
- Create a new Lectic file (`.lec` extension)
  - File will be created with a template including:
    - Interlocutor configuration
    - Model settings
    - Context management options
    - Tool integration settings

### Features
- Automatic filetype detection for `.lec` files
- Markdown syntax support with concealing
- Folding support via Treesitter
- Status line integration showing current model

### Chat Commands
- `:Lectic chat` - Start a new chat session
- `:Lectic context add` - Add current buffer to chat context
- `:Lectic context clear` - Clear chat context
- `:Lectic history` - Show chat history

### Configuration Commands
- `:Lectic config` - Open Lectic configuration
- `:Lectic model <name>` - Switch to different model
- `:Lectic reload` - Reload Lectic configuration

### Keybindings in Chat Mode
- `<C-k>` - Scroll up in chat history
- `<C-j>` - Scroll down in chat history
- `<C-c>` - Cancel current request
- `<CR>` - Send message
- `<C-e>` - Toggle chat window expansion

### Advanced Features
- **Context Management**
  - Use `:Lectic context show` to view current context
  - Context is preserved between sessions
  - Supports multiple file types including code
  
- **Custom Commands**
  - Define custom commands in `init.lua`
  - Create shortcuts for common operations
  - Integrate with other plugins

### Troubleshooting
- If Lectic fails to load:
  - Check plugin installation in `lazy.nvim`
  - Verify API key configuration
  - Ensure dependencies are installed
  - Check log with `:Lectic debug`
