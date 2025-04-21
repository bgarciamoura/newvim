if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["bashls"] = {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	root_markers = { ".git", ".bashrc", ".bash_profile" },
	single_file_support = true,
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command)",
			shellcheckPath = "shellcheck", -- Caminho para o shellcheck se disponível
		},
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("bashls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Bash: " .. tostring(err), vim.log.levels.ERROR)
end
