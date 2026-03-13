# Neovim Cheatsheet for Writing with AI

## Movement, Navigation and Modes

### Mode Switching
- `<Esc>` or `Ctrl+[` - Enter Normal mode
- `i` - Enter Insert mode before cursor
- `a` - Enter Insert mode after cursor

#### Basic Normal Mode Movement
- `h/j/k/l` - Left/Down/Up/Right
- `{` - Jump to previous paragraph
- `}` - Jump to next paragraph
- `Ctrl+u` - Scroll half page up
- `Ctrl+d` - Scroll half page down
- `w` - Move to start of next word
- `b` - Move to start of previous word
- `e` - Move to end of word
- `0` - Move to start of line
- `$` - Move to end of line
- `gg` - Go to first line of document
- `G` - Go to last line of document

#### Basic Insert Mode Movement
Horizontal movement:
- <M-Left> = Option + Left arrow → start of display line
- <M-Right> = Option + Right arrow → end of display line

Vertical movement:
- <M-Up> = Option + Up arrow → start of paragraph
- <M-Down> = Option + Down arrow → end of paragraph

### Visual Mode and Selection
Visual Mode Types:
- `v` - Character-wise Visual mode (selects just the current character)
- `V` (Shift+v) - Line-wise Visual mode (selects entire current line)
- `Ctrl+v` - Block-wise Visual mode (selects in columns)
- `gv` - Reselect the previous visual selection

After entering visual mode:
- `h/j/k/l` - Extend selection by character in any direction
- `w` - Extend selection to start of next word
- `b` - Extend selection back to start of previous word
- `e` - Extend selection to end of word
- `$` or `End` - Extend selection to end of line
- `0` or `Home` - Extend selection to start of line
- `^` - Extend selection to first non-blank character
- `G` - Extend selection to end of file
- `gg` - Extend selection to start of file
- `o` - Jump cursor to other end of selection
- `gv` - Reselect the last visual selection

Quick Selection Commands (from normal mode):
- `viw` - Select inner word
- `vaw` - Select a word (includes trailing space)
- `vis` - Select inner sentence
- `vas` - Select a sentence
- `vip` - Select inner paragraph
- `vap` - Select a paragraph
- `vi"` - Select text inside quotes
- `va"` - Select text including quotes
- `vi(` or `vi)` - Select text inside parentheses
- `va(` or `va)` - Select text including parentheses
- `vi{` or `vi}` - Select text inside curly braces
- `va{` or `va}` - Select text including curly braces
- `vit` - Select text inside HTML/XML tags
- `vat` - Select text including HTML/XML tags

Selection with Counts:
- `v2w` - Select 2 words forward
- `v2b` - Select 2 words backward
- `v4j` - Select 4 lines down
- `v4k` - Select 4 lines up

After Selection:
- `y` - Yank (copy) selection
- `d` - Delete selection
- `c` - Change (delete and enter insert mode)
- `>` - Indent selection right
- `<` - Indent selection left
- `=` - Auto-indent selection
- `u` - Make selection lowercase
- `U` - Make selection uppercase
- `~` - Toggle case of selection
- `Esc` or `Ctrl-[` - Exit visual mode

### Normal Mode Movement

#### Basic Movement
- `h/j/k/l` - Left/Down/Up/Right
- `{` - Jump to previous paragraph
- `}` - Jump to next paragraph
- `Ctrl+u` - Scroll half page up
- `Ctrl+d` - Scroll half page down
- `w` - Move to start of next word
- `b` - Move to start of previous word
- `e` - Move to end of word
- `0` - Move to start of line
- `$` - Move to end of line
- `gg` - Go to first line of document
- `G` - Go to last line of document

#### Wrapped Line Navigation
- `gj` - Move down one displayed line (works with wrapped text)
- `gk` - Move up one displayed line (works with wrapped text)
- `g$` - Move to end of displayed line
- `g0` - Move to start of displayed line
- `g^` - Move to first non-blank character of displayed line

#### Quick Word Movement
- `5w` - Move forward 5 words (replace 5 with any number)
- `3e` - Move to the end of 3rd word ahead
- `4b` - Move back 4 words
- `25w` - Move forward 25 words
- Tip: Combine with `v` for visual selection: `v25w` selects 25 words ahead

#### Paragraph and Screen Movement
- `{` - Jump to previous paragraph
- `}` - Jump to next paragraph
- `Ctrl+u` - Scroll half page up
- `Ctrl+d` - Scroll half page down
- `zz` - Center cursor on screen
- `5j` or `5k` - Jump down/up 5 lines (replace 5 with any number)
- `50G` or `:50` - Jump to line 50
- `*` - Jump to next occurrence of word under cursor
- `#` - Jump to previous occurrence of word under cursor
- `/word` - Search forward for 'word'
- `?word` - Search backward for 'word'
- `n` - Jump to next search match
- `N` - Jump to previous search match
- `fx` - Jump to next 'x' on current line
- `Fx` - Jump to previous 'x' on current line
- `;` - Repeat last f/F movement forward
- `,` - Repeat last f/F movement backward


## Text Manipulation

### Copying and Pasting
- `yy` - Yank (copy) current line
- `yw` - Yank word
- `y$` - Yank to end of line
- `p` - Paste after cursor
- `P` - Paste before cursor

### Deleting and Changing
- `dd` - Delete current line
- `dw` - Delete word
- `d$` or `D` - Delete to end of line
- `cc` - Change entire line
- `cw` - Change word
- `c$` or `C` - Change to end of line
- `ciw` - Change inner word (cursor can be anywhere in word)
- `caw` - Change around word (includes trailing space)
- `viwp` - Select inner word and paste over it
- `viw"0p` - Select word and paste from register 0 over it
- `:%s/old/new/g` - Replace all instances of 'old' with 'new'
- `:%s/old/new/gc` - Replace all instances with confirmation
- `:s/old/new/g` - Replace all instances in current line
- `*` then `cgn` - Change next match of word under cursor
- `gd` then `cgn` - Go to definition and change next match

### Quick Replace Tips
- `vep` - Select word and replace with last yanked text
- `viw` then `p` - Select inner word and paste over it
- `R` - Enter Replace mode (overwrite existing text)
- `r` - Replace single character
- `S` - Delete line and enter insert mode
- `guu` - Make line lowercase
- `gUU` - Make line uppercase
- `g~iw` - Toggle case of current word

### Understanding Text Objects

Text objects are powerful Vim concepts that let you operate on chunks of text. They come in two flavors:
- `i` (inner) - select/operate on just the object
- `a` (around) - select/operate on the object and surrounding whitespace/delimiters

Examples:
- `w` (word): 
  - In text "Hello, world":
  - `iw` selects just "Hello"
  - `aw` selects "Hello" plus the following space and comma
- `"` (quotes):
  - In text: 'He said "hello there"'
  - `i"` selects "hello there"
  - `a"` selects "hello there" including the quotes
- `p` (paragraph):
  - `ip` selects inner paragraph (text between blank lines)
  - `ap` selects around paragraph (including blank lines)

Common text object combinations:
- `ciw` - Change inner word (change just the word under cursor)
- `caw` - Change around word (change word and trailing space)
- `ci"` - Change text inside quotes
- `ca"` - Change text including quotes
- `ci(` - Change text inside parentheses
- `ci{` - Change text inside curly braces
- `cit` - Change text inside HTML/XML tags
- `cap` - Change entire paragraph

You can replace `c` (change) with:
- `d` for delete
- `y` for yank (copy)
- `v` for select

### Surround (nvim-surround)

Add, delete, or change surrounding pairs like `"..."`, `(...)`, `[...]`, `{...}`.

**Add surrounds** (normal mode):
- `ys` + motion + char — surround a motion (e.g. `ysiw"` wraps inner word in `"`)
- `yss` + char — surround current line
- `yS` + motion + char — surround a motion, putting pair on new lines
- `ySS` + char — surround current line, putting pair on new lines

**Add surrounds** (visual mode):
- `S` + char — surround selection
- `gS` + char — surround selection, putting pair on new lines

**Delete/change surrounds** (normal mode):
- `ds` + char — delete surrounding pair (e.g. `ds"` removes `"..."`)
- `cs` + char + char — change surrounding pair (e.g. `cs"(` changes `"..."` to `(...)`)
- `cS` + char + char — change surrounding pair, putting replacement on new lines

**Insert mode**:
- `Ctrl-g s` + char — surround around cursor
- `Ctrl-g S` + char — surround around cursor, on new lines

**Common examples**:
- `ysiw"` — surround word under cursor with quotes → `"word"`
- `ysiw(` — surround word with parens → `(word)`
- `ysip"` — surround paragraph with quotes
- `ds"` — remove surrounding quotes
- `cs"'` — change `"hello"` to `'hello'`
- `cs"(` — change `"hello"` to `(hello)`
- Select text, press `S"` — wrap selection in quotes

## File Information

### Showing File Path and Status
- `:f` or `Ctrl-g` - Show current file path and status
- `1 Ctrl-g` - Show full file path
- `2 Ctrl-g` - Show full file path and buffer number
- `:pwd` - Show present working directory
- `:echo expand('%')` - Show relative path of current file
- `:echo expand('%:p')` - Show full path of current file
- `:echo expand('%:t')` - Show just the file name
- `:echo expand('%:p:h')` - Show full directory path
- `set laststatus=2` - Always show status line with file info
- `Shift-ctrl + / Shift-ctrl -` - Zoom In / Out 

### File Status Information
- `:ls` - List buffers (shows file paths)
- `g Ctrl-g` - Show detailed file info (cursor position, bytes, chars)
- `:filetype` - Show filetype of current buffer
- `:set fileencoding` - Show file encoding
- `:version` - Show Vim version and build info
- `:w filename.md` - Save current buffer as new file
- `:w` - Save current file
- `:w /full/path/to/dir/filename.md` - Save to new location with new name
- `:w ~/Documents/filename.md` - Save to home directory (~ expansion works)
- `:w %:h/newname.md` - Save in same directory as current file with new name
- `:w ../filename.md` - Save in parent directory
- `:e filename.md` - Open existing file
- `:e .` - Open file explorer
- `:bd` - Close current buffer
- `:q` - Quit current window
- `:wq` or `:x` - Save and quit
- `:q!` - Quit without saving
- `:w filename.md` - Save current buffer as new file
- `:w` - Save current file
- `:e filename.md` - Open existing file
- `:e .` - Open file explorer
- `:bd` - Close current buffer
- `:q` - Quit current window
- `:wq` or `:x` - Save and quit
- `:q!` - Quit without saving

### File System Operations
- `:saveas newname.md` - Save as new file while keeping original
- `:w >> filename.md` - Append current buffer to existing file
- `:!mv -i % newname.md` - Rename current file with overwrite protection
- `:!mv -n % newname.md` - Rename current file, don't overwrite if exists
- `:!mv % ../newdir/` - Move current file to different directory
- `:!rm filename.md` - Delete a file from the filesystem
- `:!mkdir dirname` - Create a new directory
- `:!rmdir dirname` - Remove an empty directory
- `:w !sudo tee %` - Save file with sudo privileges (when opened without sudo)

Note: The `!` prefix allows executing shell commands from within Neovim
IMPORTANT: When using `:!mv`, add `-i` flag for interactive prompts or `-n` to prevent overwriting


## AI Writing Assistant (Lectic)

Single-party AI conversations with 12 personas (multi-party mode disabled - broken in beta6). See [lectic-cheatsheet.md](lectic-cheatsheet.md) for details.

### Keybindings

**Markdown/Writing (`<leader>m`)**:
- `<leader>mz` - Toggle zen mode
- `<leader>mw` - Write all buffers
- `<leader>mn` - New Lectic file (creates with Homie persona)
- `<leader>ml` - Run Lectic on current file
- `<leader>ms` - Submit visual selection with message
- `<leader>mc` - Insert context link template (use Ctrl+x Ctrl+f for path completion)
- `<leader>md` - Dictate (speech-to-text) - press once to start, again to stop/transcribe
- `<leader>mv` - Markdown preview toggle
- `<leader>mu` - Open URL under cursor
- `<leader>mp` - Switch persona submenu (see below)
- `<leader>mt` - Toggles submenu (completion, folding)

**Persona Switching (`<leader>mp`)**:
- `c` - Consultant, `m` - Marketing, `f` - Finance, `p` - Product
- `r` - Researcher, `w` - Writer, `e` - Editor
- `d` - Designer, `s` - Scholar, `b` - Scribe
- `h` - Homie, `n` - Nomad

**Context Files**: Add markdown links in document body: `[Context](/absolute/path.md)` - use `<leader>mc` for quick insertion


## Finding Files & Searching (Telescope)

### Second Brain Search (Absolute Paths)
- `<leader>fr` - Recent files
- `<leader>ff` - Brain files (all of ~/SecondBrain)
- `<leader>fb` - Grep brain (search all of ~/SecondBrain)
- `<leader>fz` - Grep zettelkasten (`~/SecondBrain/4-Zettelkasten/`)
- `<leader>fl` - Grep literature notes (`~/SecondBrain/Literature/`)

### Buffer & Context Search
- `<leader>fc` - Search current buffer
- `<leader>fo` - Search all open buffers
- `<leader>fw` - Search project for word under cursor

### Dev Search (CWD-Relative) - `<leader>fd` submenu
- `<leader>fdf` - Find files in current working directory
- `<leader>fdg` - Grep current working directory
- `<leader>fdc` - Grep nvim config (`~/.config/nvim`)
- `<leader>fds` - Search nvim config files

### Utility Searches
- `<leader>fp` - Resume previous search
- `<leader>fy` - Yank history
- `<leader>fk` - Search keymaps
- `<leader>fh` - Search help docs
- `Ctrl+p` - Quick file finder (cwd)


## Search and Replace

### Basic Search
- `/pattern` - Search forward for pattern
- `?pattern` - Search backward for pattern
- `n` - Next search result
- `N` - Previous search result
- `*` - Search for word under cursor
- `#` - Search backward for word under cursor

### Global Replace
- `:%s/old/new/g` - Replace all occurrences
- `:%s/old/new/gc` - Replace with confirmation


## Markdown Specific

### Headers
- `#` to `######` - Different header levels
- `-` or `*` - Unordered list
- `1.` - Ordered list
- `**text**` - Bold
- `*text*` - Italic
- `[text](url)` - Link
- ````code```` - Code block


## Tips and Tricks

### Quick Actions
- `.` - Repeat last command
- `u` - Undo
- `Ctrl+r` - Redo
- `>>`/`<<` - Indent/outdent line
- `=G` - Auto-indent to end of file


## Window Management

In Neovim, "windows" (also called panes in other tools like tmux) are viewports into buffers. Multiple windows can show different buffers, or the same buffer from different positions.

### Session Management
- `<leader>ss` - Save current session (saves layout, buffers, positions)
- `<leader>sl` - Load session (Telescope picker)
- `<leader>sd` - Delete session
- `<leader>mz` - Zen mode (focus current window, toggle to restore layout)

**Note**: Sessions are saved per directory. Use different cwds for different sessions in the same project.

### Creating Windows (Splits)

**Custom keybindings** (directional):
- `<leader>wl` - New window right (vertical split)
- `<leader>wh` - New window left (vertical split)
- `<leader>wj` - New window below (horizontal split)
- `<leader>wk` - New window above (horizontal split)
- `<leader>ws` - Buffer split (same buffer in new window)
- `<leader>wx` - Close current window

**Native Vim commands**:
- `:sp` or `:split` - Split horizontally (new window below)
- `:vsp` or `:vsplit` - Split vertically (new window right)
- `:new` - Create new horizontal split with empty buffer
- `:vnew` - Create new vertical split with empty buffer
- `Ctrl-w s` - Split horizontally (like `:split`)
- `Ctrl-w v` - Split vertically (like `:vsplit`)
- `:sp filename` - Split and open file
- `:vsp filename` - Vertical split and open file

### Navigating Between Windows
- `Ctrl-w h` - Move to window left
- `Ctrl-w j` - Move to window below
- `Ctrl-w k` - Move to window above
- `Ctrl-w l` - Move to window right
- `Ctrl-w w` - Cycle through windows
- `Ctrl-w p` - Go to previous window
- `Ctrl-w t` - Go to top-left window
- `Ctrl-w b` - Go to bottom-right window

### Resizing Windows
- `Ctrl-w =` - Make all windows equal size
- `Ctrl-w _` - Maximize height of current window
- `Ctrl-w |` - Maximize width of current window
- `Ctrl-w >` - Increase window width
- `Ctrl-w <` - Decrease window width
- `Ctrl-w +` - Increase window height
- `Ctrl-w -` - Decrease window height
- `:resize 20` - Set window height to 20 rows
- `:vertical resize 80` - Set window width to 80 columns
- `10 Ctrl-w >` - Increase width by 10

### Moving/Rearranging Windows
- `Ctrl-w r` - Rotate windows downward/rightward
- `Ctrl-w R` - Rotate windows upward/leftward
- `Ctrl-w x` - Exchange current window with next
- `Ctrl-w H` - Move window to far left
- `Ctrl-w J` - Move window to bottom
- `Ctrl-w K` - Move window to top
- `Ctrl-w L` - Move window to far right

### Closing Windows
- `:q` - Close current window
- `:on` or `:only` - Close all windows except current
- `Ctrl-w c` - Close current window
- `Ctrl-w o` - Close all other windows
- `:qa` - Close all windows and quit Vim


## Buffer Management

### Understanding Buffers:
- A buffer is an in-memory text file loaded into Vim
- Files are what's on disk, buffers are what's in memory
- Windows are viewports that show buffers

### Listing and Navigating Buffers
- `:ls` or `:buffers` - List all buffers
  - `%` marks the current buffer
  - `#` marks the alternate buffer
  - `a` marks an active buffer (loaded and visible)
  - `h` marks a hidden buffer
  - `+` marks a modified buffer
- `:b {number}` - Jump to buffer by number (shown in `:ls`)
- `:b {name}` - Jump to buffer by name (tab completion works)
- `:bn` or `:bnext` - Go to next buffer
- `:bp` or `:bprev` - Go to previous buffer
- `:b#` - Go to alternate buffer (last buffer you were in)
- `Ctrl-6` or `Ctrl-^` - Toggle between current and alternate buffer

### Managing Buffers
- `:bd` or `:bdelete` - Delete current buffer
- `:bd {number}` - Delete buffer by number
- `:bd {name}` - Delete buffer by name
- `:bw` or `:bwipe` - Completely remove buffer from memory
- `:ball` - Open all buffers in windows
- `:unhide` or `:sunhide` - Open all loaded buffers in windows
- `:badd {name}` - Add new buffer without opening it
- `:bufdo {cmd}` - Execute command on all buffers
- `:wa` or `:wall` - Write all modified buffers
- `:qa` or `:qall` - Close all buffers and exit
- `:wqa` - Write and close all buffers

### Buffer States
- `:set hidden` - Allow switching buffers without saving
- `:e!` - Reload current buffer (discard changes)
- `:bufdo e!` - Reload all buffers
- `:bufdo %s/old/new/ge | update` - Replace in all buffers and save

### Tips for Buffer Management
1. Use `:b {partial}` + Tab for quick buffer switching
2. Numbers in `:ls` output stay constant during session
3. Use `:bufdo` for bulk operations across files
4. `set hidden` is useful to navigate without saving
5. Combine with splits: `:sb {number}` to open buffer in new split

### The Buffer-Window-File Relationship
1. Files (on disk)
   - Permanent storage
   - What you eventually save to
   - Not directly edited

2. Buffers (in memory)
   - Working copy of a file
   - Where edits happen
   - Can be hidden or visible
   - Can be modified without saving
   - Multiple buffers can exist without windows

3. Windows (viewports)
   - Views into buffers
   - Multiple windows can show same buffer
   - Closing a window doesn't affect the buffer
   - Window arrangements are temporary
   - Each window must show a buffer

### Window vs Buffer
- Windows are views into buffers
- Multiple windows can show the same buffer
- Closing a window doesn't close the buffer
- `:ls` shows buffers, not windows
- `:windows` shows all windows

### Tips for Window Management
1. Use `Ctrl-w` prefix for most window operations
2. Combine with buffers: `:sb {buffer}` opens buffer in new split
3. Use `:only` when you need to focus on one thing
4. Remember window commands use `hjkl` like navigation
5. Numbers work with resize commands (e.g., `10 Ctrl-w >`)

### Common Workflows
- `Ctrl-w s` then `Ctrl-w j` then `:b {name}` - Split and open different buffer below
- `Ctrl-w v` then `Ctrl-w l` then `:e {file}` - Split and open file on right
- `:vsp` then `Ctrl-w =` - Create equal vertical splits

### Marks and Jumps
- `ma` - Set mark 'a'
- `` `a `` - Jump to mark 'a'
- `Ctrl+o` - Jump to previous position
- `Ctrl+i` - Jump to next position

## Best Practices

1. Save frequently with `:w`
2. Use marks to remember important positions
3. Utilize text objects for efficient editing
4. Keep context relevant when working with AI
5. Use appropriate models for different tasks
6. Maintain clear document structure with proper markdown formatting

Remember: This cheatsheet can be expanded as you discover more useful commands and workflows. Keep it handy and update it as needed!

## Insert Mode Navigation

### Basic Movement in Insert Mode
- `Ctrl-h` - Delete character before cursor (like backspace)
- `Ctrl-w` - Delete word before cursor
- `Ctrl-u` - Delete all characters before cursor in current line
- `Ctrl-t` - Add indent in current line
- `Ctrl-d` - Remove indent in current line
- `Ctrl-o` - Enter Normal mode for ONE command, then return to Insert mode
- `Ctrl-r {register}` - Paste from register (e.g., Ctrl-r " to paste from default register)

### Navigation in Insert Mode
- `Ctrl-f` - Move one character forward (right)
- `Ctrl-b` - Move one character backward (left)
- `Ctrl-o $` - Move to end of line (using Ctrl-o for a normal mode command)
- `Ctrl-o w` - Move to beginning of next word
- `Ctrl-o e` - Move to end of current/next word
- `Ctrl-o b` - Move to beginning of previous word
- `Ctrl-o {` - Move to previous paragraph
- `Ctrl-o }` - Move to next paragraph

### Insert Mode Tips
1. The `Ctrl-o` command is your friend - it lets you execute ANY normal mode command without leaving insert mode
2. Examples using Ctrl-o:
   - `Ctrl-o zz` - Center screen on cursor
   - `Ctrl-o A` - Jump to end of line and stay in insert mode
   - `Ctrl-o I` - Jump to start of line and stay in insert mode
   - `Ctrl-o o` - Insert line below and stay in insert mode
   - `Ctrl-o O` - Insert line above and stay in insert mode

### Best Practices
1. While these commands exist, it's often more efficient to:
   - Use Normal mode for navigation (hit `<Esc>` or `Ctrl-[`)
   - Make your movement in Normal mode
   - Return to Insert mode with `i`, `a`, `o`, etc.
2. Consider using these Insert mode commands when:
   - Making small adjustments while typing
   - Needing to execute just one Normal mode command
   - Wanting to stay in Insert mode for flow

## How Neovim Plugins Work (with Lazy)

### Initial Setup and Plugin Directory Structure
```
~/.config/nvim/           # Your Neovim config directory
└── lua/
    └── your_config/
        └── plugins/      # Plugin configurations
            ├── telescope.lua
            ├── treesitter.lua
            └── ... other plugin files

~/.local/share/nvim/lazy/ # Where Lazy installs plugins
└── *plugin-directories*  # Each plugin gets its own directory
```

**Configuration Approaches**:
- **Single File**: All plugin configs in one file (often `lazy.lua`)
  ```lua
  -- lazy.lua
  return {
    { "plugin1/repo" },
    { "plugin2/repo" },
    -- all plugins here
  }
  ```
- **Split File**: Each plugin has its own config file (more organized)
  ```lua
  -- telescope.lua
  return {
    "nvim-telescope/telescope.nvim",
    -- telescope specific config
  }
  ```

### Plugin Management Process

1. **Configuration Reading**:
   - Lazy reads all plugin configuration files on startup
   - Each file specifies:
     - Plugin source (GitHub repository)
     - Loading conditions
     - Settings and dependencies
     - Custom configurations

2. **Plugin Installation**:
   - Lazy checks `~/.local/share/nvim/lazy/` for installed plugins
   - For missing plugins:
     - Creates plugin directory
     - Clones repository
     - Installs dependencies
     - Runs any build steps

3. **Plugin Loading**:
   - Determines load timing:
     - Immediate loading
     - Lazy loading (on events/commands)
   - For each plugin:
     - Sources plugin files
     - Applies configurations
     - Sets up commands/keymaps

4. **State Management**:
   - Maintains state in `~/.local/state/nvim/lazy/state.json`
   - Tracks:
     - Installed plugins
     - Versions (commits)
     - Load times
     - Plugin health

### Example Plugin Configuration
```lua
return {
  "plugin-name/repo",
  lazy = true,                -- Don't load immediately
  cmd = "PluginCommand",     -- Load on this command
  dependencies = {           -- Required plugins
    "other/plugin"
  },
  config = function()        -- Setup function
    require("plugin").setup({
      -- your settings
    })
  end
}
```

### Performance Features
- Lazy-loads plugins only when needed
- Caches plugin states
- Compiles Lua code
- Efficient dependency management
- Parallel plugin downloads

### Common Lazy.nvim Commands
- `:Lazy` - Open Lazy menu
- `:Lazy install` - Install missing plugins
- `:Lazy update` - Update plugins
- `:Lazy clean` - Remove unused plugins
- `:Lazy check` - Check for updates
- `:Lazy log` - Open log
- `:Lazy restore` - Restore plugin state
