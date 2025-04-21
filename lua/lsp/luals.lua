if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	-- Filetypes para anexar automaticamente.
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" }, -- Adicionar '.git' como root marker adicional
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			-- Adicionar diagnósticos aprimorados
			diagnostics = {
				globals = { "vim" }, -- Reconhecer 'vim' como global
			},
			-- Adicionar configuração de workspace
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
	-- Garantir que capabilities esteja definido
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Envolva a chamada de enable em pcall para capturar erros
local success, err = pcall(function()
	vim.lsp.enable("luals")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Lua LS: " .. tostring(err), vim.log.levels.ERROR)
end
