-- vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })
vim.keymap.set("n", "<leader>l", ":checkhealth vim.lsp<cr>", { silent = true })
vim.keymap.set("i", "<C-s>", "<esc>:w<cr>", { silent = true })
-- Autocomplete
vim.keymap.set("i", "<C-Space>", function()
	vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })

-- Diagnosticos
-- Variável para rastrear o estado atual
local diagnostics_inline = true

-- Função para alternar diagnósticos
local function toggle_diagnostics()
	diagnostics_inline = not diagnostics_inline

	if diagnostics_inline then
		-- Ativa diagnósticos inline e desativa float
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 4 },
			float = false,
		})
		vim.notify("Diagnósticos inline ativados", vim.log.levels.INFO)
	else
		-- Desativa diagnósticos inline e ativa float
		vim.diagnostic.config({
			virtual_text = false,
			float = {
				source = "always",
				border = "rounded",
				focusable = false,
			},
		})
		vim.notify("Diagnósticos flutuantes ativados", vim.log.levels.INFO)
	end
end

-- Mapeia a tecla <leader>d para alternar diagnósticos
vim.keymap.set("n", "<leader>d", toggle_diagnostics, { desc = "Alternar diagnósticos inline/float" })
