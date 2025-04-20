return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"DaikyXendo/nvim-material-icon",
	},
	event = "VeryLazy",
	config = function()
		local diagnostics = {
			"diagnostics",
			sources = { "nvim_lsp" },
			sections = { "error", "warn", "info", "hint" },
			symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
			colored = true,
			update_in_insert = false,
			always_visible = false,
		}

		-- Cache para evitar chamadas frequentes de LSP
		local lsp_clients_cache = {}
		local lsp_timer = nil
		local lsp_cache_time = 3000 -- ms

		local function get_lsp_clients()
			-- Verificar cache primeiro
			local bufnr = vim.api.nvim_get_current_buf()
			local cache_key = tostring(bufnr)

			if lsp_clients_cache[cache_key] and lsp_clients_cache[cache_key].time > (vim.loop.now() - lsp_cache_time) then
				return lsp_clients_cache[cache_key].value
			end

			-- Obter clientes LSP
			local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
			if #buf_clients == 0 then
				lsp_clients_cache[cache_key] = { time = vim.loop.now(), value = "No LSP" }
				return "No LSP"
			end

			local client_names = {}
			for _, client in ipairs(buf_clients) do
				table.insert(client_names, client.name)
			end

			local result = "LSP: " .. table.concat(client_names, ", ")
			lsp_clients_cache[cache_key] = { time = vim.loop.now(), value = result }
			return result
		end

		-- Limpar o cache quando um cliente LSP se conectar ou desconectar
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				lsp_clients_cache[tostring(bufnr)] = nil
			end,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			callback = function(args)
				local bufnr = args.buf
				lsp_clients_cache[tostring(bufnr)] = nil
			end,
		})

		local colors = {
			black = "#16161D", -- sumiInk0
			white = "#DCD7BA", -- fujiWhite
			red = "#E82424", -- samuraiRed
			green = "#98BB6C", -- springGreen
			blue = "#7E9CD8", -- crystalBlue
			yellow = "#DCA561", -- autumnYellow
			gray = "#C8C093", -- oldWhite
			darkgray = "#1F1F28", -- sumiInk3
			lightgray = "#2A2A37", -- sumiInk4
			inactivegray = "#54546D", -- sumiInk6
		}

		local kanagawa_theme = {
			normal = {
				a = { bg = colors.gray, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.darkgray, fg = colors.gray },
			},
			insert = {
				a = { bg = colors.blue, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.lightgray, fg = colors.white },
			},
			visual = {
				a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.inactivegray, fg = colors.black },
			},
			replace = {
				a = { bg = colors.red, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.white },
			},
			command = {
				a = { bg = colors.green, fg = colors.black, gui = "bold" },
				b = { bg = colors.lightgray, fg = colors.white },
				c = { bg = colors.inactivegray, fg = colors.black },
			},
			inactive = {
				a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
				b = { bg = colors.darkgray, fg = colors.gray },
				c = { bg = colors.darkgray, fg = colors.gray },
			},
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = kanagawa_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "dashboard", "alpha", "neo-tree" },
					winbar = { "dashboard", "alpha", "neo-tree" },
				},
				ignore_focus = { "neo-tree" },
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 200,
					tabline = 2000,
					winbar = 2000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", diagnostics },
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						get_lsp_clients,
						cond = function()
							local ft = vim.bo.filetype
							return ft ~= "neo-tree"
						end,
					},
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {
				"lazy",
				"mason",
				"neo-tree",
			},
		})
	end,
}
