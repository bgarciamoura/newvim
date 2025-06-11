return {
        group_name = "Telescope",
        group_prefix = "<leader>f",
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
		{
			"n",
			"<leader>ca",
			"<cmd>Telescope lsp_code_actions<CR>",
			"Code Actions (Telescope)",
		},
		{
			"v",
			"<leader>ca",
			"<cmd>Telescope lsp_range_code_actions<CR>",
			"Code Actions Range (Telescope)",
		},

		-- Outros LSP mappings úteis com Telescope
		{
			"n",
			"<leader>lr",
			"<cmd>Telescope lsp_references<CR>",
			"LSP References (Telescope)",
		},
		{
			"n",
			"<leader>ls",
			"<cmd>Telescope lsp_document_symbols<CR>",
			"Document Symbols (Telescope)",
		},
		{
			"n",
			"<leader>lS",
			"<cmd>Telescope lsp_workspace_symbols<CR>",
			"Workspace Symbols (Telescope)",
		},
		{
			"n",
			"<leader>ld",
			"<cmd>Telescope diagnostics<CR>",
			"Diagnostics (Telescope)",
		},
		{
			"n",
			"<leader>li",
			"<cmd>Telescope lsp_implementations<CR>",
			"Implementations (Telescope)",
		},
		{
			"n",
			"<leader>lt",
			"<cmd>Telescope lsp_type_definitions<CR>",
			"Type Definitions (Telescope)",
		},
	},
}
