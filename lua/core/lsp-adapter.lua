local M = {}

-- Função para verificar se o Neovim está na versão 0.11 ou superior
function M.is_nvim_0_11_plus()
	local major, minor = vim.version().major, vim.version().minor
	return major > 0 or (major == 0 and minor >= 11)
end

-- Função para garantir compatibilidade da API LSP entre Neovim 0.10 e 0.11
function M.enable_lsp_compatibility()
	if not M.is_nvim_0_11_plus() then
		-- Estamos em uma versão anterior a 0.11, não é necessário adaptar
		return
	end

	-- Verifica se vim.lsp.config já existe
	if not vim.lsp.config then
		vim.lsp.config = {}
	end

	-- Wrapper para tornar vim.lsp.enable compatível
	local original_enable = vim.lsp.enable
	vim.lsp.enable = function(server_name)
		if not vim.lsp.config[server_name] or not vim.lsp.config[server_name].cmd then
			vim.notify(
				"Erro ao habilitar o servidor LSP '" .. server_name .. "': configuração incompleta (faltando 'cmd').",
				vim.log.levels.ERROR
			)
			return false
		end

		-- Garante que capabilities e filetypes existam
		vim.lsp.config[server_name].capabilities = vim.lsp.config[server_name].capabilities
			or vim.lsp.protocol.make_client_capabilities()
		vim.lsp.config[server_name].filetypes = vim.lsp.config[server_name].filetypes or {}

		-- Tenta habilitar o servidor
		local success, err = pcall(original_enable, server_name)
		if not success then
			vim.notify("Falha ao habilitar LSP '" .. server_name .. "': " .. tostring(err), vim.log.levels.ERROR)
			return false
		end
		return true
	end

	-- Adiciona um verificador para garantir que as configurações estejam válidas
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function(args)
			local filetype = args.match

			-- Procura servidores LSP configurados para este filetype
			for server_name, config in pairs(vim.lsp.config) do
				if config.filetypes and vim.tbl_contains(config.filetypes, filetype) then
					-- Verifica se o servidor já está em execução para este buffer
					local is_attached = false
					local clients = vim.lsp.get_clients({ bufnr = args.buf })
					for _, client in ipairs(clients) do
						if client.name == server_name then
							is_attached = true
							break
						end
					end

					-- Se o servidor não está em execução, tenta iniciá-lo
					if not is_attached then
						-- Atrasamos a inicialização para garantir que outros eventos terminem
						vim.defer_fn(function()
							pcall(vim.lsp.enable, server_name)
						end, 100)
					end
				end
			end
		end,
	})
end

return M
