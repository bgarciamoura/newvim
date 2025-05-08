-- Funções utilitárias para LSP
local M = {}

-- Função para determinar a raiz do projeto (versão atualizada)
function M.get_project_root()
	local root_files = { ".git", "package.json", "biome.json" }
	local startpath = vim.fn.expand("%:p:h")

	-- Buscar o primeiro arquivo de raiz encontrado
	local root_file = vim.fs.find(root_files, { path = startpath, upward = true })[1]

	if root_file then
		return vim.fs.dirname(root_file)
	end
	return nil
end

-- Função para verificar se 'biome.json' existe na raiz do projeto
function M.has_biome_config(root)
	if not root then
		return false
	end

	local biome_path = vim.fs.joinpath(root, "biome.json")
	return vim.loop.fs_stat(biome_path) ~= nil
end

-- Configura integração Biome/ESLint
function M.setup_biome_eslint_integration()
	-- Autocomando para aplicar correções ao salvar arquivos
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
		callback = function()
			local root = M.get_project_root()
			if M.has_biome_config(root) then
				-- Aplicar correções com o Biome
				vim.fn.jobstart({
					"biome",
					"check",
					"--apply",
					"--quiet",
					"--no-errors-on-exit",
					"--no-format-on-error",
					vim.api.nvim_buf_get_name(0),
				}, {
					cwd = root,
					on_exit = function(_, _)
						-- Ignoramos códigos de erro para não bloquear o salvamento
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
end

-- Função para inicializar a integração Biome/ESLint
function M.setup()
	M.setup_biome_eslint_integration()
end

-- Inicializa o módulo
M.setup()

return M
