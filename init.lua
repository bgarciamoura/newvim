---@diagnostic disable-next-line: undefined-global
local vim = vim

require("core.options")
require("core.diagnostics")
require("core.autocmds")
require("core.lazy")

-- Adicionar adaptador de compatibilidade LSP para Neovim 0.11
require("core.lsp-adapter").enable_lsp_compatibility()

-- Carrega primeiro o arquivo de capacidades aprimoradas para garantir que todos os LSPs usem essas capacidades
require("core.lsp-enhanced-capabilities").enhance_all_lsp_configs()

-- Carrega todos os arquivos LSP de forma alternativa
local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"
local handle = vim.loop.fs_scandir(lsp_dir)
if handle then
	while true do
		local name, type = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end

		if type == "file" and name:match("%.lua$") then
			local module_name = name:sub(1, -5) -- Remove '.lua' da extensão
			local success, err = pcall(function()
				require("lsp." .. module_name)
			end)
			if not success then
				vim.notify("Erro ao carregar LSP module: " .. module_name .. " - " .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end
end

-- Verificar se a função inlay_hint existe antes de chamá-la
if vim.lsp.inlay_hint and type(vim.lsp.inlay_hint.enable) == "function" then
	vim.lsp.inlay_hint.enable()
end

vim.cmd("colorscheme kanagawa")

-- Configura os highlights do cmp após aplicar o tema
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		require("core.cmp-highlights").setup()
	end,
})

-- Ativa os highlights no início
require("core.cmp-highlights").setup()
