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
		-- Atalho para abrir o painel Trouble
		vim.keymap.set("n", "<leader>xx", function()
			require("trouble").toggle()
		end)
	end,
}
