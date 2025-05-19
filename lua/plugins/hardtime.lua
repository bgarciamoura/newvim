return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		require("hardtime").setup({
			max_count = 5,
			max_time = 1000,
			disable_filetypes = { "TelescopePrompt", "NvimTree", "neo-tree" },
			disable_mouse = false,
			disabled_keys = {
				["<Up>"] = false,
				["<Down>"] = false,
				["<Left>"] = false,
				["<Right>"] = false,
			},
		})
	end,
}
