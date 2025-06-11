local vim = vim
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
return {
        group_name = "Diagnostics",
        group_prefix = "<leader>d",
        mappings = {
		{
			"n",
			"<leader>d",
			toggle_diagnostics,
			"Alternar diagnósticos inline/float",
		},
	},
}
