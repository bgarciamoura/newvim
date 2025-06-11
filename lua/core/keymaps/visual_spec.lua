return {
        group_name = "Visual",
        group_prefix = "<leader>v",
        mappings = {
		-- Desindentar/indentar mantendo seleção
		{ "v", "<", "<gv", "Des‑indentar e manter seleção" },
		{ "v", ">", ">gv", "Indentar e manter seleção" },

		-- Mover bloco selecionado
		{ "v", "<C-j>", "<Cmd>m '>+1<CR>gv=gv", "Mover bloco ↓" },
		{ "v", "<C-k>", "<Cmd>m '<-2<CR>gv=gv", "Mover bloco ↑" },

		-- Colar sem sobrescrever o registro 0
		{ "v", "p", '"_dP', "Colar sem copiar substituído" },

		-- Clipboard & busca/substituição
		{ "v", "<leader>c", '"+y', "Copiar seleção p/ clipboard", { nowait = true } },
		{ "v", "<leader>s", "y/<C-r>0<CR>", "Buscar seleção", { nowait = true } },
		{
			"v",
			"<leader>sr",
			"y:%s/<C-r>0//g<Left><Left>",
			"Substituir seleção global",
			{ nowait = true },
		},
	},
}
