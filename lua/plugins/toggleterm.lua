return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	config = function()
        require("toggleterm").setup({
                size = 20,
                open_mapping = [[<c-\>]],
                shade_terminals = true,
                direction = "horizontal",
        })
	end,
}
