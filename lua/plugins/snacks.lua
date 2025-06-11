-- Utilidade para calcular porcentagem de linhas/colunas
local function pct(val, total)
	return math.floor(total * val)
end
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
                                width = 0.75,
                                -- reduce height to add margin around the
                                -- dashboard so the header is not flush with
                                -- the top of the window
                                height = 0.8,
                                min_width = 40,
                                min_height = 15,
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
                                -- add extra top padding so the header is not
                                -- flush with the top edge of the window
                                { section = "header", gap = 10, pane = 1, padding = { 4, 0 } },
				{ section = "keys", gap = 1, padding = 1, pane = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 1, 1 }, pane = 1 },
				{
					pane = 1,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = pct(0.25, vim.o.lines),
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, pane = 1 },
				{ section = "startup", pane = 1 },
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
