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

			vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })

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

		-- COMPLETAÇÃO: Deixa o LSP funcionando normalmente para funcionalidades como auto-import
		-- O blink.cmp vai interceptar e usar as capabilities do LSP sem desabilitá-las
		if client:supports_method("textDocument/completion") then
			-- NÃO desabilitamos o completion provider, apenas não habilitamos o sistema nativo
			-- O blink.cmp vai usar essas capabilities através do provider LSP
			-- vim.notify("LSP " .. client.name .. " attached - completion handled by blink.cmp", vim.log.levels.DEBUG)
		end
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

-- Função para verificar se ESLint está configurado no projeto
local function has_eslint_config(root)
	if not root then
		return false
	end
	local eslint_configs = {
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		".eslintrc",
		"eslint.config.js",
		"eslint.config.cjs",
	}

	for _, config in ipairs(eslint_configs) do
		if vim.fn.filereadable(vim.fs.joinpath(root, config)) == 1 then
			return true
		end
	end

	-- Também verifica se existe config no package.json
	local package_json_path = vim.fs.joinpath(root, "package.json")
	if vim.fn.filereadable(package_json_path) == 1 then
		local ok, package_content = pcall(vim.fn.readfile, package_json_path)
		if ok then
			local package_str = table.concat(package_content, "\n")
			local package_json = vim.fn.json_decode(package_str)
			if package_json and package_json.eslintConfig then
				return true
			end
		end
	end

	return false
end

-- Função para verificar se o cliente ESLint está anexado
local function has_eslint_lsp_client()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		if client.name == "eslint" then
			return true
		end
	end
	return false
end

-- Autocomando para aplicar correções ao salvar arquivos
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
	callback = function()
		local root = get_project_root()

		-- Primeiro, tenta usar o Biome se estiver configurado
		if has_biome_config(root) then
			vim.fn.jobstart({ "biome", "check", "--apply", vim.api.nvim_buf_get_name(0) }, {
				cwd = root,
				on_exit = function(_, code)
					if code ~= 0 then
						vim.notify("Erro ao aplicar correções com o Biome", vim.log.levels.WARN)
					else
						-- Recarrega o buffer para mostrar as mudanças
						vim.cmd("edit")
					end
				end,
			})
		-- Depois, verifica se tem ESLint configurado E o LSP anexado
		elseif has_eslint_config(root) and has_eslint_lsp_client() then
			-- Usa o comando LSP do ESLint
			vim.lsp.buf.execute_command({
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(0),
						version = vim.lsp.util.buf_versions[0],
					},
				},
			})
		-- Como último recurso, usa apenas o formatador LSP padrão
		else
			-- Usa o formatador padrão do LSP (conform.nvim já está configurado no seu projeto)
			local conform = require("conform")
			if conform then
				conform.format({
					bufnr = 0,
					timeout_ms = 3000,
					lsp_fallback = true,
				})
			else
				-- Fallback para formatação nativa do LSP
				vim.lsp.buf.format({
					bufnr = 0,
					timeout_ms = 3000,
					async = false,
				})
			end
		end
	end,
})

-------------------------------------------------------------
--- END LINT FIX COM BIOME CASO EXISTA OU ESLINT COMO FALLBACK
-------------------------------------------------------------

-- Função para remover todos os comentários do buffer atual
local function remove_all_comments()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local parsers = require("nvim-treesitter.parsers")

	-- Verifica se o treesitter está disponível para o buffer atual
	local parser = parsers.get_parser()
	if not parser then
		vim.notify("Treesitter parser não disponível para este tipo de arquivo", vim.log.levels.WARN)
		return
	end

	local tree = parser:parse()[1]
	local root = tree:root()
	local query = vim.treesitter.query.parse(parser:lang(), "(comment) @comment")

	local comments = {}

	-- Coleta todos os nós de comentário
	for id, node in query:iter_captures(root, 0) do
		local name = query.captures[id]
		if name == "comment" then
			local start_row, start_col, end_row, end_col = node:range()
			table.insert(comments, {
				start_row = start_row,
				start_col = start_col,
				end_row = end_row,
				end_col = end_col,
			})
		end
	end

	-- Ordena os comentários por posição (do final para o início para não afetar as posições)
	table.sort(comments, function(a, b)
		if a.start_row == b.start_row then
			return a.start_col > b.start_col
		end
		return a.start_row > b.start_row
	end)

	-- Remove os comentários
	local removed_count = 0
	for _, comment in ipairs(comments) do
		local lines = vim.api.nvim_buf_get_lines(0, comment.start_row, comment.end_row + 1, false)

		if #lines == 1 then
			-- Comentário em uma única linha
			local line = lines[1]
			local before = line:sub(1, comment.start_col)
			local after = line:sub(comment.end_col + 1)
			local new_line = before .. after

			-- Se a linha ficar vazia (só whitespace), remove a linha inteira
			if new_line:match("^%s*$") then
				vim.api.nvim_buf_set_lines(0, comment.start_row, comment.end_row + 1, false, {})
			else
				vim.api.nvim_buf_set_lines(0, comment.start_row, comment.end_row + 1, false, { new_line })
			end
		else
			-- Comentário em múltiplas linhas
			local first_line = lines[1]:sub(1, comment.start_col)
			local last_line = lines[#lines]:sub(comment.end_col + 1)
			local new_line = first_line .. last_line

			-- Se a linha resultante ficar vazia, remove completamente
			if new_line:match("^%s*$") then
				vim.api.nvim_buf_set_lines(0, comment.start_row, comment.end_row + 1, false, {})
			else
				vim.api.nvim_buf_set_lines(0, comment.start_row, comment.end_row + 1, false, { new_line })
			end
		end

		removed_count = removed_count + 1
	end

	vim.notify(string.format("Removidos %d comentário(s)", removed_count), vim.log.levels.INFO)
end

-- Cria o comando
vim.api.nvim_create_user_command("RemoveComments", remove_all_comments, {
	desc = "Remove todos os comentários do buffer atual usando treesitter",
})

-- Opcionalmente, cria um mapeamento de tecla
vim.keymap.set("n", "<leader>rc", remove_all_comments, {
	desc = "Remove todos os comentários",
	silent = true,
})
