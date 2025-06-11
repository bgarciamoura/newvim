return {
        group_name = "Basics",
        group_prefix = "<leader>b",
        mappings = {
		{ "n", "<C-a>", "<Cmd>keepjumps normal! ggVG<CR>", "Selecionar todo o texto" },
		{ "n", "<C-s>", "<Cmd>w<CR>", "Salvar arquivo" },
		{ "n", "<C-q>", "<Cmd>q<CR>", "Sair" },
		{ "n", "ZZ", "<Cmd>x<CR>", "Salvar e sair" },
		{ "n", "<C-C>", "<Cmd>let @/ = ''<CR>", "Limpar padrão de busca", { nowait = true } },
		{ "n", "ycc", "yygccp", "Copiar e comentar linha, depois colar abaixo", { remap = true } },
	},
}
