---@diagnostic disable-next-line: undefined-global
local vim = vim

require("core.options")
require("core.diagnostics")
require("core.autocmds")
require("core.lazy")


-- Anterior: Carregar capacidades LSP e busca dos arquivos .lua no diretório LSP
-- Agora Mason + LSPConfig irá gerenciar isso, então essas linhas podem ser removidas

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
