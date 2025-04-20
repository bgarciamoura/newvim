return {
	mappings = {
		-- Criar splits
		{ "n", "<leader>ws", "<Cmd>split<CR>", "Dividir horizontalmente", { nowait = true } },
		{ "n", "<leader>wv", "<Cmd>vsplit<CR>", "Dividir verticalmente", { nowait = true } },

		-- Fechar / isolar
		{ "n", "<leader>wc", "<C-w>c", "Fechar janela atual", { nowait = true } },
		{ "n", "<leader>wo", "<C-w>o", "Fechar outras janelas", { nowait = true } },

		-- Navegação entre janelas
		{ "n", "<leader>wj", "<C-w>j", "Ir para janela abaixo", { nowait = true } },
		{ "n", "<leader>wk", "<C-w>k", "Ir para janela acima", { nowait = true } },
		{ "n", "<leader>wh", "<C-w>h", "Ir para janela à esquerda", { nowait = true } },
		{ "n", "<leader>wl", "<C-w>l", "Ir para janela à direita", { nowait = true } },

		-- Redimensionamento rápido
		{ "n", "<leader>w=", "<C-w>=", "Equalizar janelas", { nowait = true } },
		{ "n", "<leader>w+", "<Cmd>resize +5<CR>", "Aumentar altura", { nowait = true } },
		{ "n", "<leader>w-", "<Cmd>resize -5<CR>", "Diminuir altura", { nowait = true } },
		{ "n", "<leader>w>", "<Cmd>vertical resize +5<CR>", "Aumentar largura", { nowait = true } },
		{ "n", "<leader>w<", "<Cmd>vertical resize -5<CR>", "Diminuir largura", { nowait = true } },
	},
}
