return {
        event = "TermOpen",
        buffer_local = true,
        group_name = "Terminal",
        group_prefix = "<leader>t",
        mappings = {
		{ "t", "<Esc>", "<C-\\><C-n>", "Sair do modo terminal" },
		{ "t", "<C-h>", "<C-\\><C-n><C-w>h", "Janela à esquerda" },
		{ "t", "<C-j>", "<C-\\><C-n><C-w>j", "Janela abaixo" },
		{ "t", "<C-k>", "<C-\\><C-n><C-w>k", "Janela acima" },
		{ "t", "<C-l>", "<C-\\><C-n><C-w>l", "Janela à direita" },
	},
}
