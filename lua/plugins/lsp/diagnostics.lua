local M = {}

-- Configuração padrão para diagnósticos
function M.setup()
	vim.diagnostic.config({
		virtual_text = {
			prefix = "●",
			spacing = 4,
			severity = vim.diagnostic.severity.WARN,
			current_line = true,
		},
		update_in_insert = true,
		float = false,
	})

	-- Ativar floating window for diagnostic
	vim.api.nvim_create_autocmd("CursorHold", {
		group = vim.api.nvim_create_augroup("ShowDiagnosticsFloat", { clear = true }),
		callback = function()
			-- Verifica se está no modo Normal
			if vim.fn.mode() ~= "n" then
				return
			end

			-- Obtém a configuração atual de diagnósticos
			local config = vim.diagnostic.config()
			local virtual_text = config.virtual_text

			-- Verifica se virtual_text está desativado
			local is_virtual_text_disabled = false
			if virtual_text == false then
				is_virtual_text_disabled = true
			elseif type(virtual_text) == "table" and virtual_text.prefix == nil then
				is_virtual_text_disabled = true
			end

			-- Se virtual_text estiver desativado, exibe a janela flutuante
			if is_virtual_text_disabled then
				vim.diagnostic.open_float(nil, {
					focus = false,
					scope = "line",
					source = "always",
					border = "rounded",
				})
			end
		end,
	})

	-- Comandos para ativar/desativar diagnósticos virtuais
	vim.api.nvim_create_user_command("EnableVirtualText", function()
		vim.diagnostic.config({ virtual_text = true })
	end, {})

	vim.api.nvim_create_user_command("DisableVirtualText", function()
		vim.diagnostic.config({ virtual_text = false })
	end, {})
end

-- Inicializa o módulo
M.setup()

return M
