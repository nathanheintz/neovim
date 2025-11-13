local M = {}

M.preset = {
	pick = nil,
	keys = {
		{ icon = " ", key = "s", desc = "Restore Session", action = ":SessionManager load_session" },
		{ icon = " ", key = "e", desc = "Explorer", action = ":Neotree toggle" },
		{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
		{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
		--   { icon = "󰱼", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
    { icon = " ", key = "n", desc = "New Lectic File", action = ":lua CreateNewLecticFile()" },
		{ icon = " ", key = "b", desc = "Second Brain", action = ":Neotree toggle ~/SecondBrain" },
    { icon = "󱙝 ", key = "g", desc = "Ghost Dev", action = ":Neotree toggle ~/ghostdev" },
    { icon = "󰱼 ", key = "z", desc = "Search Zettelkasten", action = ":lua Snacks.dashboard.pick('live_grep', {cwd = '~/SecondBrain'})", },
    { icon = "󰯂 ", key = "l", desc = "Search Lit Notes", action = ":lua Snacks.dashboard.pick('live_grep', {cwd = '~/SecondBrain/4-Resources/Literature'})", },
		{ icon = " ", key = "c", desc = "Config", action = ":Neotree toggle ~/.config" },
    { icon = " ", key = "a", desc = "About", action = ":e ~/.config/nvim/README.md" },
		{ icon = "  ", key = "i", desc = "Cheatsheet", action = ":e ~/.config/nvim/cheatsheet-readme/nvim-cheatsheet.md", },
		{ icon = " ", key = "m", desc = "Manage Plugins", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
		{ icon = " ", key = "q", desc = "Quit", action = ":qa!" },
		--    { icon = " ", key = "h", desc = "Checkhealth", action = ":checkhealth" },
		--    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
	},

	-- header = [[
	--
	--                                               
	--        ████ ██████           █████      ██
	--       ███████████             █████ 
	--       █████████ ███████████████████ ███   ███████████
	--      █████████  ███    █████████████ █████ ██████████████
	--     █████████ ██████████ █████████ █████ █████ ████ █████
	--   ███████████ ███    ███ █████████ █████ █████ ████ █████
	--  ██████  █████████████████████ ████ █████ █████ ████ ██████
	--                                                                        ]],

	--
	-- @@@  @@@  @@@@@@@@   @@@@@@   @@@  @@@  @@@  @@@@@@@@@@
	-- @@@@ @@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@  @@@@@@@@@@@
	-- @@!@!@@@  @@!       @@!  @@@  @@!  @@@  @@!  @@! @@! @@!
	-- !@!!@!@!  !@!       !@!  @!@  !@!  @!@  !@!  !@! !@! !@!
	-- @!@ !!@!  @!!!:!    @!@  !@!  @!@  !@!  !!@  @!! !!@ @!@
	-- !@!  !!!  !!!!!:    !@!  !!!  !@!  !!!  !!!  !@!   ! !@!
	-- !!:  !!!  !!:       !!:  !!!  :!:  !!:  !!:  !!:     !!:
	-- :!:  !:!  :!:       :!:  !:!   ::!!:!   :!:  :!:     :!:
	--  ::   ::   :: ::::  ::::: ::    ::::     ::  :::     ::
	-- ::    :   : :: ::    : :  :      :      :     :      :
	--

	header = [[
                                             o8o                    
                                             `"'                    
ooo. .oo.    .ooooo.   .ooooo.  oooo    ooo oooo  ooo. .oo.  .oo.   
`888P"Y88b  d88' `88b d88' `88b  `88.  .8'  `888  `888P"Y88bP"Y88b  
 888   888  888ooo888 888   888   `88..8'    888   888   888   888  
 888   888  888    .o 888   888    `888'     888   888   888   888  
o888o o888o `Y8bod8P' `Y8bod8P'     `8'     o888o o888o o888o o888o

]],
}

M.sections = {
	{ section = "header" }, -- no padding needed
	{ section = "keys", gap = 0, padding = 1 }, -- 1 line below
	{ section = "startup", padding = 2 }, -- 2 lines below (space before ronin when stacked)
	-- {
	-- 	section = "terminal",
	-- 	cmd = "ascii-image-converter ~/.config/ronin.png -C -c -W 40; sleep 0.1",
	-- 	pane = 2,
	-- 	indent = 6,
	-- 	height = 40,
	-- 	ttimeoutlen = 0,
	-- },
}

return M
