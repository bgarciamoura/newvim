return {
	mappings = {
		{
			"n",
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			"Trouble Toggle",
		},
		{
			"n",
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			"Buffer Diagnostics (Trouble)",
		},
		{
			"n",
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			"Symbols (Trouble)",
		},
		{
			"n",
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			esc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"n",
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			"Location List (Trouble)",
		},
		{
			"n",
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			"Quickfix List (Trouble)",
		},
	},
}
