local M = {}

-- Função para desabilitar completamente o sistema de completação nativo
function M.disable_native_completion()
	-- Desabilita a configuração global de completação
	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "Disable native completion to prevent conflicts with blink.cmp",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if not client then
				return
			end

			-- Remove completamente a capacidade de completação do cliente LSP
			-- para evitar conflitos com blink.cmp
			if client.server_capabilities and client.server_capabilities.completionProvider then
				client.server_capabilities.completionProvider = nil
				vim.notify(
					string.format("Disabled native completion for %s to prevent conflicts", client.name),
					vim.log.levels.DEBUG
				)
			end

			-- Certifica-se de que o autocomplete nativo não seja habilitado
			if client.supports_method("textDocument/completion") then
				-- NÃO chama vim.lsp.completion.enable()
				-- Deixa o blink.cmp gerenciar tudo
			end
		end,
	})
end

-- Função para configurar capabilities específicas para blink.cmp
function M.setup_blink_capabilities()
	local original_make_client_capabilities = vim.lsp.protocol.make_client_capabilities

	vim.lsp.protocol.make_client_capabilities = function()
		local capabilities = original_make_client_capabilities()

		-- Remove capabilities que podem causar conflito
		if capabilities.textDocument and capabilities.textDocument.completion then
			-- Mantém as capabilities básicas mas remove configurações conflituosas
			capabilities.textDocument.completion.completionItem = {
				snippetSupport = true,
				resolveSupport = {
					properties = { "documentation", "detail", "additionalTextEdits" },
				},
				-- Remove outras propriedades que podem causar conflito
			}
		end

		return capabilities
	end
end

-- Configuração de comando para debug
function M.setup_debug_commands()
	vim.api.nvim_create_user_command("BLinkDebugCompletion", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			print("Client:", client.name)
			print("Completion provider:", vim.inspect(client.server_capabilities.completionProvider))
		end
	end, { desc = "Debug completion setup for current buffer" })

	vim.api.nvim_create_user_command("BLinkForceDisableNative", function()
		-- Force disable native completion para troubleshooting
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.server_capabilities.completionProvider then
				client.server_capabilities.completionProvider = nil
				print("Disabled completion for:", client.name)
			end
		end
	end, { desc = "Force disable native completion for debugging" })
end

-- Função principal de setup
function M.setup()
	-- 1. Desabilita o sistema nativo
	M.disable_native_completion()

	-- 2. Configura capabilities específicas
	M.setup_blink_capabilities()

	-- 3. Adiciona comandos de debug
	M.setup_debug_commands()

	-- 4. Configuração adicional para TypeScript especificamente (comum em projetos Expo)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		callback = function()
			-- Configurações específicas para projetos JS/TS
			vim.bo.omnifunc = "" -- Remove omnifunc para evitar conflitos
		end,
	})
end

return M
