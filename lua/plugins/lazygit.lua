return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim", -- Adiciona dependência do diffview
	},
	config = function()
		-- Configuração adicional para integração com diffview
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyGitOpenPre",
			callback = function()
				-- Fecha diffview antes de abrir lazygit
				pcall(vim.cmd, "DiffviewClose")
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyGitOpen",
			callback = function()
				-- Adiciona informações de contexto quando lazygit abre
				vim.notify(
					"LazyGit aberto. Use 'q' para sair e <leader>dpr para revisar mudanças no Diffview",
					vim.log.levels.INFO
				)
			end,
		})

		-- Comando customizado para workflow completo
		vim.api.nvim_create_user_command("GitWorkflow", function()
			-- Primeiro abre lazygit para fazer commits
			vim.cmd("LazyGit")

			-- Quando lazygit fechar, sugere abrir diffview
			vim.defer_fn(function()
				vim.ui.select({ "Sim", "Não" }, {
					prompt = "Abrir Diffview para revisar mudanças?",
				}, function(choice)
					if choice == "Sim" then
						vim.cmd("DiffviewOpen HEAD~1")
					end
				end)
			end, 1000)
		end, { desc = "Workflow completo: LazyGit + Diffview" })
	end,
	keys = {
		{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
		{ "<leader>gc", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
		{ "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
		{ "<leader>gw", "<cmd>GitWorkflow<cr>", desc = "Git Workflow (LazyGit + Diffview)" },
	},
}
