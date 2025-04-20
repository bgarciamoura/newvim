local M = {}

-- Função para melhorar as capacidades do LSP para o nvim-cmp
function M.get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- Adiciona suporte para snippets
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	-- Adiciona suporte para diversas funcionalidades de autocomplete
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	-- Adiciona suporte para preenchimento de tags
	capabilities.textDocument.completion.completionItem.preselectSupport = true
	capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }

	-- Adiciona suporte para várias linhas
	capabilities.textDocument.completion.completionItem.insertTextModeSupport = { valueSet = { 1, 2 } }

	-- Adiciona suporte para edição adicional de texto
	capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }

	-- Se o plugin cmp-nvim-lsp estiver disponível, use-o para melhorar as capacidades
	local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if has_cmp then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	return capabilities
end

-- Função para aplicar essas capacidades a todos os LSP configurados
function M.enhance_all_lsp_configs()
	local capabilities = M.get_capabilities()

	-- Aplica essas capacidades a todas as configurações LSP existentes
	for server_name, _ in pairs(vim.lsp.config) do
		if vim.lsp.config[server_name] then
			vim.lsp.config[server_name].capabilities =
				vim.tbl_deep_extend("force", vim.lsp.config[server_name].capabilities or {}, capabilities)
		end
	end
end

return M
