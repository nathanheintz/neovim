--[[ WHICH-KEY MAPPINGS - QUICK REFERENCE

NOTE: These mappings are also documented in ~/.config/nvim/README.md
Please maintain consistency between both documents when making changes.

----------------------------------------------------------------------------------
TOP-LEVEL MAPPINGS (<leader>)                   | DESCRIPTION
----------------------------------------------------------------------------------
<leader>b - VimtexCompile                       | Compile LaTeX document
<leader>c - Create vertical split               | Split window vertically
<leader>d - Save and delete buffer              | Save file and close buffer
<leader>e - Toggle NeoTree explorer            | Open/close file explorer
<leader>j - Close split                         | Close current split window
<leader>i - Open VimtexToc                      | Show LaTeX table of contents
<leader>k - Maximize split                      | Make current window full screen
<leader>q - Save all and quit                   | Save all files and exit Neovim
<leader>u - Open Telescope undo                 | Show undo history with preview
<leader>v - VimtexView                          | View compiled LaTeX document
<leader>w - WRITING tools (zen, word count)                     | Save all open files
----------------------------------------------------------------------------------
TOP-LEVEL MAPPINGS (<leader>)                   | DESCRIPTION
----------------------------------------------------------------------------------
<leader>b - VimtexCompile                       | Compile LaTeX document
<leader>c - Create vertical split               | Split window vertically
<leader>d - Save and delete buffer              | Save file and close buffer
<leader>e - Toggle NeoTree explorer            | Open/close file explorer
<leader>j - Close split                         | Close current split window
<leader>i - Open VimtexToc                      | Show LaTeX table of contents
<leader>k - Maximize split                      | Make current window full screen
<leader>q - Save all and quit                   | Save all files and exit Neovim
<leader>u - Open Telescope undo                 | Show undo history with preview
<leader>v - VimtexView                          | View compiled LaTeX document
<leader>w - WRITING tools (zen, word count)                     | Save all open files

----------------------------------------------------------------------------------
ACTIONS (<leader>a)                             | DESCRIPTION
----------------------------------------------------------------------------------
<leader>aa - PDF annotations                    | Work with PDF annotations
<leader>ab - Export bibliography                | Export BibTeX to separate file
<leader>ac - Clear VimTex cache                 | Clear LaTeX compilation cache
<leader>ae - Show VimTex errors                 | Display LaTeX error messages
<leader>af - Format buffer                      | Format current buffer via LSP
<leader>ag - Edit glossary                      | Open LaTeX glossary template
<leader>ah - Toggle local highlight             | Highlight current word occurrences
<leader>ak - Clean VimTex aux files             | Remove LaTeX auxiliary files
<leader>al - Toggle Lean info view              | Show/hide Lean information panel
<leader>am - Run model checker                  | Execute model checker on file
<leader>ap - Run Python file                    | Execute current Python file
<leader>ar - Recalculate autolist               | Fix numbering in lists
<leader>at - Format tex file                    | Format LaTeX using latexindent
<leader>au - Update CWD                         | Change to file's directory
<leader>av - VimTex context menu                | Show VimTeX context actions
<leader>aw - Count words                        | Count words in LaTeX document
<leader>as - Edit snippets                      | Open snippets directory
<leader>aS - SSH connect                        | Connect to MIT server via SSH

----------------------------------------------------------------------------------
FIND (<leader>f)                                | DESCRIPTION
----------------------------------------------------------------------------------
<leader>fa - Find all files                     | Search all files, including hidden
<leader>fb - Find buffers                       | Switch between open buffers
<leader>fc - Find citations                     | Search BibTeX citations
<leader>ff - Find in project                    | Search text in project files
<leader>fl - Resume last search                 | Continue previous search
<leader>fq - Find in quickfix                   | Search within quickfix list
<leader>fg - Git commit history                 | Browse git commit history
<leader>fh - Help tags                          | Search Neovim help documentation
<leader>fk - Keymaps                            | Show all keybindings
<leader>fr - Registers                          | Show clipboard registers
<leader>ft - Colorschemes                       | Browse and change themes
<leader>fs - Search string                      | Search for string in project
<leader>fw - Search word under cursor           | Find current word in project
<leader>fy - Yank history                       | Browse clipboard history

----------------------------------------------------------------------------------
GIT (<leader>g)                                 | DESCRIPTION
----------------------------------------------------------------------------------
<leader>gb - Checkout branch                    | Switch to another git branch
<leader>gc - View commits                       | Show commit history
<leader>gd - View diff                          | Show changes against HEAD
<leader>gg - Open lazygit                       | Launch terminal git interface
<leader>gk - Previous hunk                      | Jump to previous change
<leader>gj - Next hunk                          | Jump to next change
<leader>gl - Line blame                         | Show git blame for current line
<leader>gp - Preview hunk                       | Preview current change
<leader>gs - Git status                         | Show files with changes
<leader>gt - Toggle blame                       | Toggle line blame display

----------------------------------------------------------------------------------
LIST (<leader>L)                                | DESCRIPTION
----------------------------------------------------------------------------------
<leader>Lc - Toggle checkbox                    | Check/uncheck a checkbox
<leader>Ln - Next list item                     | Move to next item in list
<leader>Lp - Previous list item                 | Move to previous item in list
<leader>Lr - Reorder list                       | Fix list numbering

----------------------------------------------------------------------------------
LSP (<leader>l)                                 | DESCRIPTION
----------------------------------------------------------------------------------
<leader>lb - Buffer diagnostics                 | Show all errors in current file
<leader>lc - Code action                        | Show available code actions
<leader>ld - Go to definition                   | Jump to symbol definition
<leader>lD - Go to declaration                  | Jump to symbol declaration
<leader>lh - Hover help                         | Show documentation under cursor
<leader>li - Implementations                    | Find implementations of symbol
<leader>lk - Kill LSP                           | Stop language server
<leader>ll - Line diagnostics                   | Show errors for current line
<leader>ln - Next diagnostic                    | Go to next error/warning
<leader>lp - Previous diagnostic                | Go to previous error/warning
<leader>lr - References                         | Find all references to symbol
<leader>ls - Restart LSP                        | Restart language server
<leader>lt - Start LSP                          | Start language server
<leader>ly - Copy diagnostics                   | Copy diagnostics to clipboard
<leader>lR - Rename                             | Rename symbol under cursor

----------------------------------------------------------------------------------
MARKDOWN (<leader>m)                            | DESCRIPTION
----------------------------------------------------------------------------------
<leader>mz - Zen mode                           | Toggle zen mode
<leader>mw - Write all                          | Save all modified buffers
<leader>ml - Run Lectic                         | Run Lectic on current file
<leader>mn - New Lectic file                    | Create multiparty Lectic file
<leader>mS - Submit selection                   | Submit visual selection with user message
<leader>mv - Markdown preview                   | Toggle markdown preview
<leader>mu - Open URL                           | Open URL under cursor
<leader>ms - Surround submenu                   | Text surround operations
<leader>mt - Toggles submenu                    | Toggle completion, folding, etc.

----------------------------------------------------------------------------------
SESSIONS (<leader>S)                            | DESCRIPTION
----------------------------------------------------------------------------------
<leader>Ss - Save session                       | Save current session
<leader>Sd - Delete session                     | Delete a saved session
<leader>Sl - Load session                       | Load a saved session

----------------------------------------------------------------------------------
PANDOC (<leader>p)                              | DESCRIPTION
----------------------------------------------------------------------------------
<leader>pw - Convert to Word                    | Convert to .docx format
<leader>pm - Convert to Markdown                | Convert to .md format
<leader>ph - Convert to HTML                    | Convert to .html format
<leader>pl - Convert to LaTeX                   | Convert to .tex format
<leader>pp - Convert to PDF                     | Convert to .pdf format
<leader>pv - View PDF                           | Open PDF in document viewer

----------------------------------------------------------------------------------
RUN (<leader>r)                                 | DESCRIPTION
----------------------------------------------------------------------------------
<leader>rc - Clear plugin cache                 | Clear Neovim plugin cache
<leader>re - Locate errors                      | Show all errors in location list
<leader>rk - Wipe plugin files                  | Remove all plugin files
<leader>rn - Next error                         | Go to next diagnostic/error
<leader>rp - Previous error                     | Go to previous diagnostic/error
<leader>rr - Reload configs                     | Reload Neovim configuration
<leader>rm - Show messages                      | Display notification history

----------------------------------------------------------------------------------
SURROUND (<leader>s)                            | DESCRIPTION
----------------------------------------------------------------------------------
<leader>ss - Surround                           | Surround with characters
<leader>sd - Delete surround                    | Remove surrounding characters
<leader>sc - Change surround                    | Change surrounding characters

----------------------------------------------------------------------------------
TEMPLATES (<leader>t)                           | DESCRIPTION
----------------------------------------------------------------------------------
<leader>tp - PhilPaper.tex                      | Insert philosophy paper template
<leader>tl - Letter.tex                         | Insert letter template
<leader>tg - Glossary.tex                       | Insert glossary template
<leader>th - HandOut.tex                        | Insert handout template
<leader>tb - PhilBeamer.tex                     | Insert beamer presentation
<leader>ts - SubFile.tex                        | Insert subfile template
<leader>tr - Root.tex                           | Insert root document template
<leader>tm - MultipleAnswer.tex                 | Insert multiple answer template
]]

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    'echasnovski/mini.nvim',
  },
  opts = {
    setup = {
      show_help = false,
      show_keys = false, -- show the currently pressed key and its label as a message in the command line
      notify = false,    -- prevent which-key from automatically setting up fields for defined mappings
      triggers = {
        { "<leader>", mode = { "n", "v" } },
      },
      plugins = {
        presets = {
          marks = false,        -- shows a list of your marks on ' and `
          registers = false,    -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = {
            enabled = false,    -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 10,   -- how many suggestions should be shown in the list?
          },
          operators = false,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = false,      -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = false,      -- default bindings on <c-w>
          nav = false,          -- misc bindings to work with windows
          z = false,            -- bindings for folds, spelling and others prefixed with z
          g = false,            -- bindings for prefixed with g
        },
      },
      win = {
        no_overlap = true,
        -- width = 1,
        -- height = { min = 4, max = 25 },
        -- col = 0,
        -- row = math.huge,
        border = "rounded", -- can be 'none', 'single', 'double', 'shadow', etc.
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        title = false,
        title_pos = "center",
        zindex = 1000,
        -- Additional vim.wo and vim.bo options
        bo = {},
        wo = {
          winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable native operators, set the preset / operators plugin above
      -- operators = { gc = "Comments" },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      layout = {
        width = { min = 20, max = 50 }, -- min and max width of the columns
        height = { min = 4, max = 25 }, -- min and max height of the columns
        spacing = 3,                    -- spacing between columns
        align = "left",                 -- align columns left, center or right
      },
      keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>",   -- binding to scroll up inside the popup
      },
      sort = { "local", "order", "group", "alphanum", "mod" },
      -- disable the WhichKey popup for certain buf types and file types.
      -- Disabled by default for Telescope
      disable = {
        bt = { "help", "quickfix", "terminal", "prompt" }, -- for example
        ft = { "neo-tree" }                                -- add your explorer's filetype here
      }
    },
    defaults = {
      buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true,  -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true,  -- use `nowait` when creating keymaps
      prefix = "<leader>",
      mode = { "n", "v" },
      d = { "<cmd>update! | lua Snacks.bufdelete()<CR>", "delete buffer" },
      e = { "<cmd>Neotree toggle<CR>", "explorer" },
      q = { "<cmd>wa! | qa!<CR>", "quit" },
      u = { "<cmd>Telescope undo<CR>", "undo" },
      w = {
        name = "WINDOW",
        c = { "<cmd>vert sb<CR>", "create split" },
        j = { "<cmd>clo<CR>", "close split" },
        k = { "<cmd>only<CR>", "maximize split" },
      },
      c = {
        name = "CODE",
        f = { "<cmd>lua vim.lsp.buf.format()<CR>", "format" },
        d = { "<cmd>Telescope lsp_definitions<CR>", "go to definition" },
        h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "hover help" },
        n = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "next error" },
        p = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "previous error" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
        r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "rename" },
      },
      a = {
        name = "ACTIONS",
        a = { "<cmd>lua PdfAnnots()<CR>", "pdf annotations" },
        h = { "<cmd>LocalHighlightToggle<CR>", "highlight word" },
        c = { "<cmd>checkhealth<CR>", "checkhealth" },
        r = { "<cmd>AutolistRecalculate<CR>", "reorder list" },
        s = { "<cmd>NeoTreeToggle ~/.config/nvim/snippets/<CR>", "edit snippets" },
        u = { "<cmd>cd %:p:h | NeoTreeToggle<CR>", "update cwd" },
      },
      f = {
        name = "FIND",
        a = { "<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, hidden = true, search_dirs = { '~/' } })<CR>", "all files" },
        f = { "<cmd>Telescope find_files<CR>", "project files" },
        g = { "<cmd>Telescope live_grep theme=ivy<CR>", "project grep" },
        b = { "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>","buffers", },
        l = { "<cmd>Telescope resume<CR>", "last search" },
        h = { "<cmd>Telescope help_tags<CR>", "help" },
        k = { "<cmd>Telescope keymaps<CR>", "keymaps" },
        r = { "<cmd>Telescope oldfiles<CR>", "recent" },
        t = { "<cmd>Telescope colorscheme<CR>", "theme" },
        s = { "<cmd>Telescope grep_string<CR>", "string" },
        w = { "<cmd>lua SearchWordUnderCursor()<CR>", "word" },
        y = { "<cmd>YankyRingHistory<CR>", "yanks" },
      },
      g = {
        name = "GIT",
        -- { '<leader>g', group = ' Git' },
        b = { "<cmd>Telescope git_branches<CR>", "checkout branch" },
        c = { "<cmd>Telescope git_commits<CR>", "git commits" },
        d = { "<cmd>Gitsigns diffthis HEAD<CR>", "diff" },
        g = { "<cmd>lua Snacks.lazygit()<cr>", "lazygit" },
        k = { "<cmd>Gitsigns prev_hunk<CR>", "prev hunk" },
        j = { "<cmd>Gitsigns next_hunk<CR>", "next hunk" },
        l = { "<cmd>Gitsigns blame_line<CR>", "line blame" }, -- TODO: use snacks?
        p = { "<cmd>Gitsigns preview_hunk<CR>", "preview hunk" },
        s = { "<cmd>Telescope git_status<CR>", "git status" },
        t = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "toggle blame" },
        -- t = { "<cmd>Gitsigns toggle_word_diff<CR>", "toggle word diff" },
      },
      -- MARKDOWN & WRITING
      m = {
        name = "MARKDOWN & WRITING",
        -- ZEN & WRITING
        z = { "<cmd>lua Snacks.zen()<CR>", "zen mode" },
        w = { "<cmd>wa!<CR>", "write all" },

        -- LECTIC COMMANDS
        l = { "<cmd>Lectic<CR>", "run lectic on file" },
        n = { "<cmd>lua CreateNewLecticFile()<CR>", "new lectic file (multiparty)" },
        S = { "<cmd>lua SubmitLecticSelection()<CR>", "submit selection with message" },
        c = { "<cmd>lua InsertContextLink()<CR>", "insert context link" },

        -- PERSONA SWITCHING
        p = {
          name = "SWITCH PERSONA",
          c = { "<cmd>lua SwitchLecticPersona('Consultant')<CR>", "consultant" },
          m = { "<cmd>lua SwitchLecticPersona('Marketing')<CR>", "marketing" },
          f = { "<cmd>lua SwitchLecticPersona('Finance')<CR>", "finance" },
          p = { "<cmd>lua SwitchLecticPersona('Product')<CR>", "product" },
          r = { "<cmd>lua SwitchLecticPersona('Researcher')<CR>", "researcher" },
          w = { "<cmd>lua SwitchLecticPersona('Writer')<CR>", "writer" },
          e = { "<cmd>lua SwitchLecticPersona('Editor')<CR>", "editor" },
          d = { "<cmd>lua SwitchLecticPersona('Designer')<CR>", "designer" },
          s = { "<cmd>lua SwitchLecticPersona('Scholar')<CR>", "scholar" },
          b = { "<cmd>lua SwitchLecticPersona('Scribe')<CR>", "scribe" },
          h = { "<cmd>lua SwitchLecticPersona('Homie')<CR>", "homie" },
          n = { "<cmd>lua SwitchLecticPersona('Nomad')<CR>", "nomad" },
        },

        -- MARKDOWN/PREVIEW
        v = { "<cmd>MarkdownPreviewToggle<CR>", "markdown preview" },
        u = { "<cmd>lua OpenUrlUnderCursor()<CR>", "open URL under cursor" },

        -- SURROUND
        s = {
          name = "SURROUND",
          s = { "<Plug>(nvim-surround-normal)", "surround" },
          d = { "<Plug>(nvim-surround-delete)", "delete surround" },
          c = { "<Plug>(nvim-surround-change)", "change surround" },
        },

        -- TOGGLES (completion, folding, etc.)
        t = {
          name = "TOGGLES",
          b = { "<cmd>lua _G.toggle_buffer_completion()<CR>", "toggle buffer completion" },
          c = { "<cmd>lua _G.toggle_spell_completion()<CR>", "toggle spell completion" },
          o = { "<cmd>lua _G.toggle_obsidian_completion()<CR>", "toggle obsidian completion" },
          x = { "<cmd>lua _G.toggle_luasnip_completion()<CR>", "toggle luasnip completion" },
          a = { "<cmd>lua ToggleAllFolds()<CR>", "toggle all folds" },
          f = { "za", "toggle fold under cursor" },
          m = { "<cmd>lua ToggleFoldingMethod()<CR>", "toggle folding method" },
        },
      },

      s = {
        name = "SESSIONS",
        s = { "<cmd>SessionManager save_current_session<CR>", "save session" },
        d = { "<cmd>SessionManager delete_session<CR>", "delete session" },
        l = { "<cmd>SessionManager load_session<CR>", "load session" },
      },
      p = {
        name = "PUBLISHING",
        -- VIMTEX / LATEX
        c = { "<cmd>VimtexCompile<CR>", "compile latex" },
        v = { "<cmd>VimtexView<CR>", "view pdf" },
        i = { "<cmd>VimtexTocOpen<CR>", "latex TOC" },

        -- VIMTEX UTILITIES
        b = { "<cmd>terminal bibexport -o %:p:r.bib %:p:r.aux<CR>", "export bibliography" },
        C = { "<cmd>VimtexClearCache All<CR>", "clear vimtex cache" },
        e = { "<cmd>VimtexErrors<CR>", "latex errors" },
        f = { "<cmd>Telescope bibtex format_string=\\citet{%s}<CR>", "find citations" },
        g = { "<cmd>e ~/.config/nvim/templates/Glossary.tex<CR>", "edit glossary" },
        k = { "<cmd>VimtexClean<CR>", "clean aux files" },
        t = { "<cmd>terminal latexindent -w %:p:r.tex<CR>", "format tex file" },
        V = { "<plug>(vimtex-context-menu)", "vimtex context menu" },
        W = { "<cmd>VimtexCountWords!<CR>", "word count (vimtex)" },

        -- PANDOC CONVERSIONS
        w = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.docx'<CR>", "convert to word" },
        m = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.md'<CR>", "convert to markdown" },
        h = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.html'<CR>", "convert to html" },
        l = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.tex'<CR>", "convert to latex" },
        p = { "<cmd>TermExec cmd='pandoc %:p -o %:p:r.pdf' open=0<CR>", "convert to pdf" },
        P = { "<cmd>TermExec cmd='zathura %:p:r.pdf &' open=0<CR>", "view pdf (zathura)" },
      },
      r = {
        name = "RUN",
        c = { "<cmd>TermExec cmd='rm -rf ~/.cache/nvim' open=0<CR>", "clear plugin cache" },
        e = { "vim.diagnostics.setloclist", "locate errors" },
        -- h = { "<cmd>Hardtime toggle<cr>", "hardtime" }, -- Hardtime plugin has been deprecated
        k = { "<cmd>TermExec cmd='rm -rf ~/.local/share/nvim/lazy &' open=0<CR>", "wipe plugin files" },
        -- m = { "<cmd>MCPHub<cr>", "mcp-hub" }, -- MCP-Hub plugin has been deprecated
        n = { "function() vim.diagnostic.goto_next{popup_opts = {show_header = false}} end", "next" },
        p = { "function() vim.diagnostic.goto_prev{popup_opts = {show_header = false}} end", "prev" },
        r = { "<cmd>ReloadConfig<cr>", "reload configs" },
        m = { "<cmd>lua Snacks.notifier.show_history()<cr>", "show messages" },
        -- d = { "function() vim.diagnostic.open_float(0, { scope = 'line', header = false, focus = false }) end", "diagnostics" },
      },
      t = {
        name = "TEMPLATES",
        l = {
          "<cmd>read ~/.config/nvim/templates/Letter.tex<CR>",
          "Letter.tex",
        },
      },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts.setup)
    wk.register(opts.defaults)
  end,
}
