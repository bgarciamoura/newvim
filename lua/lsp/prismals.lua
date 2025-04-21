if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["prismals"] = {
	cmd = { "prisma-language-server", "--stdio" },
	filetypes = { "prisma" },
	root_markers = { ".git", "package.json", "schema.prisma" },
	single_file_support = true,
	settings = {
		prisma = {
			prismaFmtBinPath = "", -- Caminho para o binário prisma-fmt, deixe vazio para usar o padrão
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
	vim.lsp.enable("prismals")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Prisma: " .. tostring(err), vim.log.levels.ERROR)
end
