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
		-- triggers = auto by default
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
		sort = { "local", "order", "group", "alphanum", "mod" },
		disable = {
			bt = { "help", "quickfix", "terminal", "prompt" },
			ft = { "neo-tree" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- PATCH: Fix Kitty terminal bug where Space in which-key menus gets corrupted
		-- See README.md for details on this patch
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				local state_file = vim.fn.stdpath("data") .. "/lazy/which-key.nvim/lua/which-key/state.lua"
				local lines = vim.fn.readfile(state_file)
				local content = table.concat(lines, "\n")

				-- Patch: Treat Space like Escape (close menu instead of buggy feedkeys)
				local patched = content:gsub(
					'elseif key == "<Esc>" then',
					'elseif key == "<Esc>" or key == "<Space>" then'
				)

				if content ~= patched then
					vim.fn.writefile(vim.split(patched, "\n"), state_file)
					vim.notify("which-key patched: Space closes menus", vim.log.levels.INFO)
				end
			end,
		})

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
			{ "<leader>wc", "<cmd>vert sb<CR>", desc = "create split" },
			{ "<leader>wj", "<cmd>clo<CR>", desc = "close split" },
			{ "<leader>wk", "<cmd>only<CR>", desc = "maximize split" },

			-- CODE
			{ "<leader>c", group = "CODE" },
			{ "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "format" },
			{ "<leader>cd", "<cmd>Telescope lsp_definitions<CR>", desc = "go to definition" },
			{ "<leader>ch", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover help" },
			{ "<leader>cn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "next error" },
			{ "<leader>cp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "previous error" },
			{ "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "code action" },
			{ "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename" },

			-- ACTIONS
			{ "<leader>a", group = "ACTIONS", icon = "󱐋" },
			{ "<leader>aa", "<cmd>lua PdfAnnots()<CR>", desc = "pdf annotations" },
			{ "<leader>ah", "<cmd>LocalHighlightToggle<CR>", desc = "highlight word" },
			{ "<leader>ac", "<cmd>checkhealth<CR>", desc = "checkhealth" },
			{ "<leader>ar", "<cmd>AutolistRecalculate<CR>", desc = "reorder list" },
			{ "<leader>as", "<cmd>NeoTreeToggle ~/.config/nvim/snippets/<CR>", desc = "edit snippets" },
			{ "<leader>au", "<cmd>cd %:p:h | NeoTreeToggle<CR>", desc = "update cwd" },

			-- FIND
			{ "<leader>f", group = "FIND" },
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "project files" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "recent" },
			{ "<leader>fc", "<cmd>lua SearchCurrentBuffer()<CR>", desc = "current buffer" },
			{ "<leader>fb", "<cmd>lua SearchAllBuffers()<CR>", desc = "all buffers" },
			{ "<leader>fw", "<cmd>lua SearchWordUnderCursor()<CR>", desc = "word" },
			{ "<leader>fg", "<cmd>Telescope live_grep theme=ivy<CR>", desc = "project grep" },
			{ "<leader>fl", "<cmd>Telescope resume<CR>", desc = "last search" },
			{ "<leader>fy", "<cmd>YankyRingHistory<CR>", desc = "yanks" },
			{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "keymaps" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "help" },

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

			-- SESSIONS
			{ "<leader>s", group = "SESSIONS" },
			{ "<leader>ss", "<cmd>SessionManager save_current_session<CR>", desc = "save session" },
			{ "<leader>sd", "<cmd>SessionManager delete_session<CR>", desc = "delete session" },
			{ "<leader>sl", "<cmd>SessionManager load_session<CR>", desc = "load session" },

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
			{ "<leader>tl", "<cmd>read ~/.config/nvim/templates/Letter.tex<CR>", desc = "Letter.tex" },
		})

	end,
}
