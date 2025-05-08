return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.lsp.capabilities") -- Capacidades LSP
			require("plugins.lsp.diagnostics") -- Configurações de diagnósticos
			require("plugins.lsp.keymaps") -- Mapeamentos de teclas
			require("plugins.lsp.filetypes") -- Configurações de tipos de arquivo
			require("plugins.lsp.servers") -- Carrega e configura servidores
		end,
	},
}
