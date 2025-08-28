local capabilities = require("blink.cmp").get_lsp_capabilities()
local lsp_keymaps = require("core.lsp-keymaps")

vim.lsp.enable({
	"lua_ls",
	"vtsls",
	"jsonls",
	"html",
	"cssls",
})

vim.diagnostic.config({ virtual_text = { prefix = "●" }, severity_sort = true })

vim.lsp.config("*", {
	capabilities = capabilities,
	on_attach = lsp_keymaps.on_attach,
})

-- POPUP de diagnósticos (erro/aviso) completos da linha/cursor
vim.diagnostic.config({
	virtual_text = { spacing = 2, prefix = "●", severity = nil }, -- pode deixar ligado
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many", -- mostra a origem (vtsls, eslint_d, etc.)
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
		max_width = 80,
		wrap = true, -- <- evita corte de mensagem longa
	},
})
