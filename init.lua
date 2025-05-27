---@diagnostic disable-next-line: undefined-global
local vim = vim

require("core.options")
require("core.diagnostics")
require("core.autocmds")
require("core.lazy")

local function remove_all_comments()
	for _, cmd in ipairs({
		"silent! %s#//.*##g",
		"silent! %s/#.*//g",
	}) do
		vim.cmd(cmd)
	end
end

vim.keymap.set("n", "<C-/>", remove_all_comments, { silent = true, desc = "Apagar todos comentários" })

-- Mantendo inlay hints (o plugin LSP irá configurar isso quando cada servidor se conectar)
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
