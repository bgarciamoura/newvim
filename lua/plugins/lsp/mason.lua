return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright", -- Python LSP
					"vtsls",
					"eslint", -- ESLint LSP for code actions
					"jsonls",
					"html",
					"cssls",
					"yamlls",
					"bashls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local tools = {
				-- Python
				"black", -- Python formatter
				"isort", -- Import sorting
				"flake8", -- Linting
				"mypy", -- Type checking
				"debugpy", -- Python debugger
				
				-- JS/TS
				"biome", -- formata e checa
				"prettierd", -- mais rápido
				"prettier", -- fallback
				"eslint_d", -- se quiser usar ESLint pra formatar

				"stylua",
				"shfmt",
				"yamlfmt",
			}

			require("mason-tool-installer").setup({
				ensure_installed = tools,
				auto_update = false, -- ligue se quiser atualizar tudo ao abrir
				run_on_start = true, -- instala/garante na inicialização
				start_delay = 3000, -- ms após o start do Neovim (evita travar boot)
				debounce_hours = 24, -- não ficar rechecando toda hora
			})
		end,
	},
}
