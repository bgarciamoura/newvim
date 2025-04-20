---@diagnostic disable-next-line: undefined-global
local vim = vim

require("core.options")
require("core.diagnostics")
require("core.autocmds")
require("core.lazy")

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
			require("lsp." .. module_name)
		end
	end
end

vim.lsp.inlay_hint.enable()
vim.cmd("colorscheme kanagawa")

-- Configura os highlights do cmp após aplicar o tema
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		require("core.cmp-highlights").setup()
	end,
})

-- Ativa os highlights no início
require("core.cmp-highlights").setup()
