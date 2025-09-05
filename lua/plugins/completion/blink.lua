return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local blink = require("blink.cmp")

			blink.setup({
				keymap = {
					preset = "enter",
					["<C-space>"] = {
						function(cmp)
							cmp.show()
						end,
					},
				},
				sources = {
					default = { "lsp", "path", "buffer" },
				},
				completion = {
					documentation = { auto_show = true },
					menu = { border = "rounded" },
					list = {
						selection = {
							preselect = false,
							auto_insert = false,
						},
					},
				},
			})
		end,
	},
}
