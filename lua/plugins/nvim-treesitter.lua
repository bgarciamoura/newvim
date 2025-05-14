return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"html",
				"css",
				"json",
				"markdown",
				"yaml",
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader><space>",
					node_incremental = "<leader><space>",
					node_decremental = "<BS>",
				},
			},
		})
	end,
}
