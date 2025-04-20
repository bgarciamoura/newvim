return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			-- Carregar o módulo de sugestões para verificação da visibilidade
			local copilot_suggestion = require("copilot.suggestion")

			-- Configurar o atalho Tab customizado
			vim.keymap.set("i", "<Tab>", function()
				if copilot_suggestion.is_visible() then
					copilot_suggestion.accept()
				else
					-- Enviar um Tab normal quando não há sugestões
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { desc = "Accept copilot suggestion or indent" })

			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = true,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true, -- Crucial para sugestões inline automáticas
					debounce = 75,
					keymap = {
						-- Removido o Tab como tecla de aceitação, será tratado pelo keymap personalizado acima
						accept = false,
						accept_word = "<M-w>", -- Aceitar apenas uma palavra
						accept_line = "<M-l>", -- Aceitar a linha inteira
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				-- Deixa o Copilot mais agressivo nas sugestões
				copilot_node_command = "node",
				server_opts_overrides = {
					inlineSuggestCount = 3, -- Mostrar mais sugestões
				},
			})
		end,
	},

	-- Integração do Copilot com o nvim-cmp
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup({
				event = { "InsertEnter", "LspAttach" },
				fix_pairs = true,
				formatters = {
					label = require("copilot_cmp.format").format_label_text,
					insert_text = require("copilot_cmp.format").format_insert_text,
					preview = require("copilot_cmp.format").deindent,
				},
				-- Usar apenas quando você explicitamente aciona o nvim-cmp
				-- (não mostra Copilot automaticamente no menu pop-up)
				sources = {
					{ name = "copilot", group_index = 2, priority = 100 },
				},
			})
		end,
	},

	-- Desativar explicitamente a versão oficial para evitar conflitos
	{
		"github/copilot.vim",
		enabled = false,
	},
}
