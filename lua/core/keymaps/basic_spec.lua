return {
	mappings = {
		{ "n", "<C-a>", "<Cmd>keepjumps normal! ggVG<CR>", "Selecionar todo o texto" },
		{ "n", "<C-s>", "<Cmd>w<CR>", "Salvar arquivo" },
		{ "n", "<C-q>", "<Cmd>q<CR>", "Sair" },
		{ "n", "ZZ", "<Cmd>x<CR>", "Salvar e sair" },
		{ "n", "<C-C>", "<Cmd>let @/ = ''<CR>", "Limpar padrão de busca", { nowait = true } },
		{
			"n",
			"<C-/>",
			"<Cmd>:g/^s*//.*$/d | g/^s*#.*$/d | g/^s*;.*$/d
<CR>",
			"Apaga todos os comentários e deixa o código",
		},
	},
}
