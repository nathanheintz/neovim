--[[ WHICH-KEY MAPPINGS - V3 FORMAT
Converted to which-key v3 add() API format
--]]

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = {
		"echasnovski/mini.nvim",
	},
	opts = {
		show_help = false,
		show_keys = true,
		notify = false,
    triggers = {
      { "<leader>", mode = { "n", "v" } },
  },
		plugins = {
			presets = {
				marks = false,
				registers = false,
				spelling = {
					enabled = false,
					suggestions = 10,
				},
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},
		win = {
			no_overlap = true,
			border = "rounded",
			padding = { 1, 2 },
			title = false,
			title_pos = "center",
			zindex = 1000,
			bo = {},
			wo = {
				winblend = 10,
			},
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
			colors = false,
		},
		layout = {
			width = { min = 20, max = 50 },
			height = { min = 4, max = 25 },
			spacing = 3,
			align = "left",
		},
		keys = {
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},
		sort = { "mod", "local", "order", "group", "manual" },
		disable = {
			bt = { "help", "quickfix", "terminal", "prompt" },
			ft = { "neo-tree" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- PATCH: Fix Kitty terminal bug where Space in which-key menus gets corrupted
		-- In-memory monkey-patch: intercepts state.check() and treats Space as Escape
		-- Only fires when a menu is already open (does NOT interfere with <leader> Space trigger)
		-- NOTE: Previous approach wrote directly to state.lua on disk (caused :Lazy update conflicts)
		-- To revert to file-writing approach, see specs/000_maintenance_debug/MAINTENANCE_LOG.md
		local state = require("which-key.state")
		local original_check = state.check
		state.check = function(s, key)
			if key == "<Space>" then key = "<Esc>" end
			return original_check(s, key)
		end

		-- Add mappings using v3 format
		wk.add({
			mode = { "n", "v" },

			-- Top-level mappings
			{ "<leader>d", "<cmd>update! | lua Snacks.bufdelete()<CR>", desc = "delete buffer" },
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "explorer", icon = "" },
			{ "<leader>q", "<cmd>wa! | qa!<CR>", desc = "quit" },
			{ "<leader>u", "<cmd>Telescope undo<CR>", desc = "undo", icon = "" },

			-- WINDOW
			{ "<leader>w", group = "WINDOW" },
			{ "<leader>wl", "<cmd>rightbelow vsplit<CR>", desc = "new win right" },
			{ "<leader>wh", "<cmd>leftabove vsplit<CR>", desc = "new win left" },
			{ "<leader>wj", "<cmd>rightbelow split<CR>", desc = "new win below" },
			{ "<leader>wk", "<cmd>leftabove split<CR>", desc = "new win above" },
			{ "<leader>wx", "<cmd>close<CR>", desc = "close window" },
			{ "<leader>ws", "<cmd>vert sb<CR>", desc = "buffer split" },

			-- CODE & CLAUDE
			{ "<leader>c", group = "CODE" },
			{ "<leader>ct", "<cmd>ClaudeCode<cr>", desc = "toggle claude" },
			{ "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "focus claude" },
			{ "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "resume claude" },
			{ "<leader>cc", "<cmd>ClaudeCode --continue<cr>", desc = "continue claude" },
			{ "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "select model" },
			{ "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "add buffer to claude" },
			{ "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "send selection to claude" },
			{ "<leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "accept diff" },
			{ "<leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "deny diff" },

			-- LSP
			{ "<leader>cl", group = "LSP" },
			{ "<leader>clf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "format" },
			{ "<leader>cld", "<cmd>Telescope lsp_definitions<CR>", desc = "go to definition" },
			{ "<leader>clh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover help" },
			{ "<leader>cln", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "next error" },
			{ "<leader>clp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "previous error" },
			{ "<leader>cla", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "code action" },
			{ "<leader>clr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename" },

			-- ACTIONS (live bindings only — dead bindings removed)
			{ "<leader>a", group = "ACTIONS", icon = "󱐋" },
			{ "<leader>ac", "<cmd>checkhealth<CR>", desc = "checkhealth" },
			{ "<leader>ar", "<cmd>AutolistRecalculate<CR>", desc = "reorder list" },
			{ "<leader>as", "<cmd>Neotree ~/.config/nvim/snippets/<CR>", desc = "edit snippets" },
			{ "<leader>au", "<cmd>cd %:p:h | Neotree<CR>", desc = "update cwd" },

			-- FIND
			{ "<leader>f", group = "FIND" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "recent" },
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files({search_dirs={'~/SecondBrain'}})<CR>", desc = "brain files" },
			{ "<leader>fb", "<cmd>lua require('telescope.builtin').live_grep({search_dirs={'~/SecondBrain'}})<CR>", desc = "grep brain" },
			{ "<leader>fz", "<cmd>lua require('telescope.builtin').live_grep({search_dirs={'~/SecondBrain/3-Zettelkasten'}})<CR>", desc = "grep zettelkasten" },
			{ "<leader>fl", "<cmd>lua require('telescope.builtin').live_grep({search_dirs={'~/SecondBrain/Literature'}})<CR>", desc = "grep lit notes" },
			{ "<leader>fc", "<cmd>lua SearchCurrentBuffer()<CR>", desc = "current buffer" },
			{ "<leader>fo", "<cmd>lua SearchAllBuffers()<CR>", desc = "open buffers" },
			{ "<leader>fw", "<cmd>lua SearchWordUnderCursor()<CR>", desc = "word project" },
			{ "<leader>fp", "<cmd>Telescope resume<CR>", desc = "previous search" },
			{ "<leader>fy", "<cmd>YankyRingHistory<CR>", desc = "yanks" },
			{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "keymaps" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "help" },

			-- DEV SEARCH
			{ "<leader>fd", group = "DEV SEARCH" },
			{ "<leader>fdf", "<cmd>Telescope find_files<CR>", desc = "find files cwd" },
			{ "<leader>fdg", "<cmd>Telescope live_grep theme=ivy<CR>", desc = "grep cwd" },
			{ "<leader>fdc", "<cmd>lua require('telescope.builtin').live_grep({search_dirs={'~/.config/nvim'}})<CR>", desc = "grep config" },
			{ "<leader>fds", "<cmd>lua require('telescope.builtin').find_files({search_dirs={'~/.config/nvim'}})<CR>", desc = "search config" },

			-- GIT
			{ "<leader>g", group = "GIT" },
			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "checkout branch" },
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "git commits" },
			{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<CR>", desc = "diff" },
			{ "<leader>gg", "<cmd>lua Snacks.lazygit()<cr>", desc = "lazygit" },
			{ "<leader>gk", "<cmd>Gitsigns prev_hunk<CR>", desc = "prev hunk" },
			{ "<leader>gj", "<cmd>Gitsigns next_hunk<CR>", desc = "next hunk" },
			{ "<leader>gl", "<cmd>Gitsigns blame_line<CR>", desc = "line blame" },
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "preview hunk" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "git status" },
			{ "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "toggle blame" },

			-- MARKDOWN & WRITING
			{ "<leader>m", group = "MARKDOWN & WRITING", icon = "󱩼" },
			{ "<leader>mz", "<cmd>lua Snacks.zen()<CR>", desc = "zen mode" },
			{ "<leader>mw", "<cmd>wa!<CR>", desc = "write all" },
			{ "<leader>ml", "<cmd>Lectic<CR>", desc = "run lectic on file" },
			{ "<leader>mn", "<cmd>lua CreateNewLecticFile()<CR>", desc = "new lectic file (multiparty)" },
			{ "<leader>ms", "<cmd>lua SubmitLecticSelection()<CR>", desc = "submit selection with message" },
			{ "<leader>mc", "<cmd>lua InsertContextLink()<CR>", desc = "insert context link" },
			{ "<leader>md", "<cmd>Vocal<CR>", desc = "dictate (speech-to-text)" },
			{ "<leader>mv", "<cmd>MarkdownPreviewToggle<CR>", desc = "markdown preview" },
			{ "<leader>mu", "<cmd>lua OpenUrlUnderCursor()<CR>", desc = "open URL under cursor" },

			-- PERSONA SWITCHING
			{ "<leader>mp", group = "SWITCH PERSONA" },
			{ "<leader>mpc", "<cmd>lua SwitchLecticPersona('Consultant')<CR>", desc = "consultant" },
			{ "<leader>mpm", "<cmd>lua SwitchLecticPersona('Marketing')<CR>", desc = "marketing" },
			{ "<leader>mpf", "<cmd>lua SwitchLecticPersona('Finance')<CR>", desc = "finance" },
			{ "<leader>mpp", "<cmd>lua SwitchLecticPersona('Product')<CR>", desc = "product" },
			{ "<leader>mpr", "<cmd>lua SwitchLecticPersona('Researcher')<CR>", desc = "researcher" },
			{ "<leader>mpw", "<cmd>lua SwitchLecticPersona('Writer')<CR>", desc = "writer" },
			{ "<leader>mpe", "<cmd>lua SwitchLecticPersona('Editor')<CR>", desc = "editor" },
			{ "<leader>mpd", "<cmd>lua SwitchLecticPersona('Designer')<CR>", desc = "designer" },
			{ "<leader>mps", "<cmd>lua SwitchLecticPersona('Scholar')<CR>", desc = "scholar" },
			{ "<leader>mpb", "<cmd>lua SwitchLecticPersona('Scribe')<CR>", desc = "scribe" },
			{ "<leader>mph", "<cmd>lua SwitchLecticPersona('Homie')<CR>", desc = "homie" },
			{ "<leader>mpn", "<cmd>lua SwitchLecticPersona('Nomad')<CR>", desc = "nomad" },

			-- SURROUND
			{ "<leader>ms", group = "SURROUND" },
			{ "<leader>mss", "<Plug>(nvim-surround-normal)", desc = "surround" },
			{ "<leader>msd", "<Plug>(nvim-surround-delete)", desc = "delete surround" },
			{ "<leader>msc", "<Plug>(nvim-surround-change)", desc = "change surround" },

			-- TOGGLES
			{ "<leader>mt", group = "TOGGLES" },
			{ "<leader>mtb", "<cmd>lua _G.toggle_buffer_completion()<CR>", desc = "toggle buffer completion", icon = " " },
			{ "<leader>mto", "<cmd>lua _G.toggle_obsidian_completion()<CR>", desc = "toggle obsidian completion" },
			{ "<leader>mtx", "<cmd>lua _G.toggle_luasnip_completion()<CR>", desc = "toggle snippet completion" },
			{ "<leader>mta", "<cmd>lua ToggleAllFolds()<CR>", desc = "toggle all folds" },
			{ "<leader>mtf", "za", desc = "toggle fold under cursor" },
			{ "<leader>mtm", "<cmd>lua ToggleFoldingMethod()<CR>", desc = "toggle folding method" },
      { "<leader>mtt", "<cmd>TableModeToggle<CR>", desc = "toggle table mode" },

			-- SESSIONS
			{ "<leader>s", group = "SESSIONS" },
			{ "<leader>ss", "<cmd>lua require('resession').save()<CR>", desc = "save session" },
			{ "<leader>sl", "<cmd>lua require('resession').load()<CR>", desc = "load session" },
			{ "<leader>sd", "<cmd>lua require('resession').delete()<CR>", desc = "delete session" },
			{ "<leader>sr", "<cmd>lua RenameSession()<CR>", desc = "rename session" },

			-- PUBLISHING
			{ "<leader>p", group = "PUBLISHING", icon = "" },
			{ "<leader>pc", "<cmd>VimtexCompile<CR>", desc = "compile latex" },
			{ "<leader>pv", "<cmd>VimtexView<CR>", desc = "view pdf" },
			{ "<leader>pi", "<cmd>VimtexTocOpen<CR>", desc = "latex TOC" },
			{ "<leader>pb", "<cmd>terminal bibexport -o %:p:r.bib %:p:r.aux<CR>", desc = "export bibliography" },
			{ "<leader>pC", "<cmd>VimtexClearCache All<CR>", desc = "clear vimtex cache" },
			{ "<leader>pe", "<cmd>VimtexErrors<CR>", desc = "latex errors" },
			{ "<leader>pf", "<cmd>Telescope bibtex format_string=\\citet{%s}<CR>", desc = "find citations" },
			{ "<leader>pg", "<cmd>e ~/.config/nvim/templates/Glossary.tex<CR>", desc = "edit glossary" },
			{ "<leader>pk", "<cmd>VimtexClean<CR>", desc = "clean aux files" },
			{ "<leader>pt", "<cmd>terminal latexindent -w %:p:r.tex<CR>", desc = "format tex file" },
			{ "<leader>pV", "<plug>(vimtex-context-menu)", desc = "vimtex context menu" },
			{ "<leader>pW", "<cmd>VimtexCountWords!<CR>", desc = "word count (vimtex)" },
			{ "<leader>pw", "<cmd>TermExec cmd='pandoc %:p -o %:p:r.docx'<CR>", desc = "convert to word" },
			{ "<leader>pm", "<cmd>TermExec cmd='pandoc %:p -o %:p:r.md'<CR>", desc = "convert to markdown" },
			{ "<leader>ph", "<cmd>TermExec cmd='pandoc %:p -o %:p:r.html'<CR>", desc = "convert to html" },
			{ "<leader>pl", "<cmd>TermExec cmd='pandoc %:p -o %:p:r.tex'<CR>", desc = "convert to latex" },
			{ "<leader>pp", "<cmd>TermExec cmd='pandoc %:p -o %:p:r.pdf' open=0<CR>", desc = "convert to pdf" },
			{ "<leader>pP", "<cmd>TermExec cmd='zathura %:p:r.pdf &' open=0<CR>", desc = "view pdf (zathura)" },

			-- RUN
			{ "<leader>r", group = "RUN", icon = "󰜎" },
			{ "<leader>rc", "<cmd>TermExec cmd='rm -rf ~/.cache/nvim' open=0<CR>", desc = "clear plugin cache" },
			{ "<leader>re", "vim.diagnostics.setloclist", desc = "locate errors" },
			{ "<leader>rk", "<cmd>TermExec cmd='rm -rf ~/.local/share/nvim/lazy &' open=0<CR>", desc = "wipe plugin files" },
			{ "<leader>rn", "function() vim.diagnostic.goto_next{popup_opts = {show_header = false}} end", desc = "next" },
			{ "<leader>rp", "function() vim.diagnostic.goto_prev{popup_opts = {show_header = false}} end", desc = "prev" },
			{ "<leader>rr", "<cmd>ReloadConfig<cr>", desc = "reload configs" },
			{ "<leader>rm", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = "show messages" },

			-- TEMPLATES
			{ "<leader>t", group = "TEMPLATES", icon = "" },
			{ "<leader>tp", "<cmd>read ~/.config/nvim/templates/PersonalLetter.tex<CR>", desc = "personal letter" },
			{ "<leader>tl", "<cmd>read ~/.config/nvim/templates/ProfessionalLetter.tex<CR>", desc = "professional letter" },
			{ "<leader>tb", "<cmd>read ~/.config/nvim/templates/SimpleBook.tex<CR>", desc = "simple book" },
			{ "<leader>ts", "<cmd>read ~/.config/nvim/templates/Screenplay.tex<CR>", desc = "screenplay" },
		{ "<leader>tc", "<cmd>read ~/.config/nvim/templates/CoachingAgreement.tex<CR>", desc = "coaching agreement" },
      { "<leader>tj", "<cmd>read ~/.config/nvim/templates/TherapeuticJournal.md<CR>", desc = "therapeutic journal" },
		})

	end,
}
