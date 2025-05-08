local M = {}

-- Obtém capacidades aprimoradas para uso nos servidores LSP
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

-- Setup inicial do Mason
function M.setup_mason()
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	require("mason-lspconfig").setup({
		-- Servidores para instalar automaticamente
		ensure_installed = {
			"lua_ls",
			"html",
			"cssls",
			"jsonls",
			"emmet_ls",
			"tailwindcss",
			"eslint",
			"marksman",
			"yamlls",
			"dockerls",
			"docker_compose_language_service",
			"prismals",
			"terraformls",
			"sqlls",
			"bashls",
			"biome",
		},
		automatic_installation = true,
	})
end

-- Configure eventos para attachment LSP
function M.setup_lsp_attach_events()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local bufnr = args.buf

			-- LSP Inlay hints
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			-- LSP Highlight
			if client.server_capabilities.documentHighlightProvider then
				local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
				vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

				vim.api.nvim_create_autocmd("CursorHold", {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd("CursorMoved", {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end

			-- Buffer-specific keymaps, se necessário
			if client.server_capabilities.completionProvider then
				vim.keymap.set("i", "<C-Space>", function()
					vim.lsp.buf.completion()
				end, { buffer = bufnr, desc = "Trigger completion" })
			end
		end,
	})
end

-- Inicializa o módulo
M.setup_mason()
M.setup_lsp_attach_events()

return M
