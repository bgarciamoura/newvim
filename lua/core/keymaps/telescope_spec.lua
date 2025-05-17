return {
	mappings = {
		{
			"n",
			"<leader>ff",
			"<Cmd>Telescope find_files<CR>",
			"Buscar arquivos",
		},
		{ "n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", "Buscar texto" },
		{ "n", "<leader>fb", "<Cmd>Telescope buffers<CR>", "Buscar buffers abertos" },
		{ "n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", "Buscar ajuda" },
		{ "n", "<leader>fr", "<Cmd>Telescope oldfiles<CR>", "Buscar arquivos recentes" },
		{ "n", "<leader>fR", "<Cmd>Telescope registers<CR>", "Buscar registros" },
	},
}
