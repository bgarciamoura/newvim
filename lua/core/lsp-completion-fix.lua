local M = {}

-- Função para debug apenas - NÃO modifica o comportamento do LSP
function M.setup_debug_commands()
	vim.api.nvim_create_user_command("BLinkDebugCompletion", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			print("Client:", client.name)
			print("Completion provider:", vim.inspect(client.server_capabilities.completionProvider))
		end
	end, { desc = "Debug completion setup for current buffer" })
end

-- Setup apenas com debugging - NÃO interfere com LSP
function M.setup()
	M.setup_debug_commands()

	-- Configuração específica para TypeScript se necessário
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		callback = function()
			-- Apenas configurações específicas de filetype, sem quebrar LSP completion
			-- vim.bo.omnifunc = "" -- REMOVIDO: Isso quebrava funcionalidades
		end,
	})
end

return M
