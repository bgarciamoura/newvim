return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				-- nenhuma configuração extra é necessária para usar o Copilot,
				-- pois ele é o adaptador padrão do CodeCompanion
			})
		end,
	},
}
