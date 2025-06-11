return {
	"folke/trouble.nvim",
	dependencies = {},
	config = function()
		require("trouble").setup({
			signs = {
				error = "🔥", -- Ícone personalizado para erros
				warning = "⚠️",
				-- hint = "💡",
				hint = "",
				information = "ℹ️",
			},
		})
        end,
}
