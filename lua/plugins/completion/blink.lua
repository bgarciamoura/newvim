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
			local luasnip = require("luasnip")

			-- Configure LuaSnip
			luasnip.config.setup({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})

			-- Load custom snippets
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

			-- Custom snippet for quotes
			luasnip.add_snippets("all", {
				luasnip.snippet("as", {
					luasnip.text_node("'"),
					luasnip.insert_node(1),
					luasnip.text_node("'"),
				}),
			})

			blink.setup({
				keymap = {
					preset = "enter",
					["<C-j>"] = { "show", "show_documentation", "hide_documentation" },
				},
				sources = {
					default = { "lsp", "path", "buffer", "snippets" },
				},
				snippets = {
					preset = "luasnip",
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
