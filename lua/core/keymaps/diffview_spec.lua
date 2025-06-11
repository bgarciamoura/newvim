return {
	mappings = {
		-- Comandos principais do Diffview
		{
			"n",
			"<leader>do",
			"<cmd>DiffviewOpen<CR>",
			"Abrir Diffview",
		},
		{
			"n",
			"<leader>dc",
			"<cmd>DiffviewClose<CR>",
			"Fechar Diffview",
		},
		{
			"n",
			"<leader>dh",
			"<cmd>DiffviewFileHistory<CR>",
			"Histórico de arquivos",
		},
		{
			"n",
			"<leader>df",
			"<cmd>DiffviewFocusFiles<CR>",
			"Focar no painel de arquivos",
		},
		{
			"n",
			"<leader>dt",
			"<cmd>DiffviewToggleFiles<CR>",
			"Alternar painel de arquivos",
		},
		{
			"n",
			"<leader>dr",
			"<cmd>DiffviewRefresh<CR>",
			"Atualizar Diffview",
		},

		-- Comandos úteis para revisão de PRs
		{
			"n",
			"<leader>dpr",
			"<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>",
			"Revisar PR (branch atual)",
		},
		{
			"n",
			"<leader>dpc",
			"<cmd>DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges<CR>",
			"Commits individuais do PR",
		},

		-- Comandos para stashes
		{
			"n",
			"<leader>dst",
			"<cmd>DiffviewFileHistory -g --range=stash<CR>",
			"Histórico de stashes",
		},

		-- Comparações específicas
		{
			"n",
			"<leader>dm",
			"<cmd>DiffviewOpen origin/main...HEAD --imply-local<CR>",
			"Diff com main/master",
		},
		{
			"n",
			"<leader>dd",
			"<cmd>DiffviewOpen HEAD~1<CR>",
			"Diff com commit anterior",
		},

		-- Integração com lazygit via keymaps
		{
			"n",
			"<leader>gl",
			function()
				-- Primeiro fecha o diffview se estiver aberto
				pcall(vim.cmd, "DiffviewClose")
				-- Depois abre o lazygit
				vim.cmd("LazyGit")
			end,
			"LazyGit (fechar diffview antes)",
		},

		-- Comando para abrir diffview após commit no lazygit
		{
			"n",
			"<leader>gd",
			function()
				-- Abre diffview para ver as últimas mudanças
				vim.cmd("DiffviewOpen HEAD~1")
			end,
			"Ver último commit no Diffview",
		},
	},
}
