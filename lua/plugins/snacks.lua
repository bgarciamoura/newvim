local total_linhas = vim.o.lines
local altura_em_linhas = math.floor(total_linhas * 0.25)
local function has_min_width(min_cols)
	return vim.o.columns >= min_cols
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			layout = {
				align = "center",
				width = 0.9, -- 90% da largura do Neovim
				height = 0.9, -- 90% da altura do Neovim
				min_width = 40, -- nunca menor que 40 colunas
				min_height = 15, -- nunca menor que 15 linhas
			},
			preset = {
				keys = {
					{ desc = "Last Session", icon = " ", action = ":SessionRestore ", key = "s" },
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ desc = "Lazygit", icon = " ", action = ":LazyGit", key = "l" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{
					section = "terminal",
					cmd = "pokemon-colorscripts -n charizard --no-title; sleep .1",
					pane = 1,
					indent = 0,
					padding = { 0, 0 },
					enabled = function()
						return has_min_width(100)
					end,
					height = math.floor(vim.o.lines * 0.40),
				},
				{ section = "header", pane = 2 },
				{ section = "keys", gap = 1, padding = 1, pane = 2 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 1, 1 }, pane = 2 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = math.floor(vim.o.lines * 0.25),
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, pane = 2 },
				{ section = "startup", pane = 2 },
				{
					section = "terminal",
					cmd = "pokemon-colorscripts -n blastoise --no-title; sleep .1",
					pane = 3,
					indent = 0,
					padding = { 0, 0 },
					enabled = function()
						return has_min_width(100)
					end,
					height = math.floor(vim.o.lines * 0.40),
				},
			},
		},
		debug = { enabled = true },
		explorer = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		layout = { enabled = true },
		lazygit = { enabled = true },
		picker = { enabled = false },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
}
