return {
	"aznhe21/actions-preview.nvim",
	event = "LspAttach",
	keys = {
		{
			"<leader>ca",
			function()
				require("actions-preview").code_actions()
			end,
			mode = { "n", "v" },
			desc = "Code action (with preview)",
		},
	},
	config = function()
		require("actions-preview").setup({
			diff = {
				algorithm = "patience",
				ignore_whitespace = true,
			},
			telescope = require("telescope.themes").get_dropdown({
				winblend = 10,
				border = true,
			}),
		})
	end,
}
