local vim = vim

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- LSP Inlay hints --
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end

		-- LSP Highlight --
		if client:supports_method("textDocument/documentHighlight") then
			local autocmd = vim.api.nvim_create_autocmd
			local augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })

			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup })

			autocmd({ "CursorHold" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			autocmd({ "CursorMoved" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client:supports_method("textDocument/completion") then
			-- Não precisamos configurar o sistema de completação nativo aqui, pois o nvim-cmp vai se encarregar disso
			-- Em vez disso, garantimos que o cliente LSP tenha as capabilities necessárias
			local has_cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if has_cmp_nvim_lsp then
				-- O nvim-cmp está instalado, então ele gerenciará o autocomplete
				client.server_capabilities.completion = client.server_capabilities.completion or {}
				client.server_capabilities.completion.completionItem = client.server_capabilities.completion.completionItem
					or {}
				client.server_capabilities.completion.completionItem.snippetSupport = true
			else
				-- Fallback para o sistema nativo caso nvim-cmp não esteja instalado
				vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			end
		end

		-- Autocomplete Nativo do Neovim 0.11
		-- if client:supports_method("textDocument/completion") then
		--   -- Optional: trigger autocompletion on EVERY keypress. May be slow!
		--   -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
		--   -- client.server_capabilities.completionProvider.triggerCharacters = chars
		--   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		-- end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		-- if not client:supports_method('textDocument/willSaveWaitUntil')
		--     and client:supports_method('textDocument/formatting') then
		--   vim.api.nvim_create_autocmd('BufWritePre', {
		--     buffer = args.buf,
		--     callback = function()
		--       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
		--     end,
		--   })
		-- end
	end,
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

-- Ativar virtual text
vim.api.nvim_create_user_command("EnableVirtualText", function()
	vim.diagnostic.config({ virtual_text = true })
end, {})

-- Desativar virtual text
vim.api.nvim_create_user_command("DisableVirtualText", function()
	vim.diagnostic.config({ virtual_text = false })
end, {})

-------------------------------------------------------------
--- LINT FIX COM BIOME CASO EXISTA OU ESLINT COMO FALLBACK
-------------------------------------------------------------

-- Função para determinar a raiz do projeto
local function get_project_root()
	local root_files = { ".git", "package.json", "biome.json" }
	return vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1])
end

-- Função para verificar se 'biome.json' existe na raiz do projeto
local function has_biome_config(root)
	return root and vim.fn.filereadable(vim.fs.joinpath(root, "biome.json")) == 1
end

-- Autocomando para aplicar correções ao salvar arquivos
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
	callback = function()
		local root = get_project_root()
		if has_biome_config(root) then
			-- Aplicar correções com o Biome
			vim.fn.jobstart({ "biome", "check", "--apply", vim.api.nvim_buf_get_name(0) }, {
				cwd = root,
				on_exit = function(_, code)
					if code ~= 0 then
						vim.notify("Erro ao aplicar correções com o Biome", vim.log.levels.ERROR)
					end
				end,
			})
		else
			-- Aplicar correções com o ESLint
			vim.lsp.buf.execute_command({
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(0),
						version = vim.lsp.util.buf_versions[0],
					},
				},
			})
		end
	end,
})

-------------------------------------------------------------
--- END LINT FIX COM BIOME CASO EXISTA OU ESLINT COMO FALLBACK
-------------------------------------------------------------
