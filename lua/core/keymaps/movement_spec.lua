return {
        group_name = "Movement",
        group_prefix = "<leader>m",
        mappings = {
		-- [[ Movimentos + Centralização ]]
		{ "n", "w", "wzz", "Próxima palavra e centralizar" },
		{ "n", "b", "bzz", "Palavra anterior e centralizar" },
		{ "n", "<C-u>", "<C-u>zz", "Scroll para cima e centralizar" },
		{ "n", "<C-d>", "<C-d>zz", "Scroll para baixo e centralizar" },
		{ "n", "J", "mzJ`z", "Juntar linha sem mover cursor" },

		-- [[ Mover Linhas ]]
		{ "n", "<C-j>", "<Cmd>m .+1<CR>==", "Mover linha para baixo" },
		{ "n", "<C-k>", "<Cmd>m .-2<CR>==", "Mover linha para cima" },
	},
}
