local vim = vim

return {
	-- aplicada somente quando um cliente LSP conectar
	event = "LspAttach",
	buffer_local = true,

	mappings = {
		-- Atalhos adicionais / overrides (os que você realmente precisa customizar)
		{ "n", "gd", vim.lsp.buf.definition, "Go to definition" },
		{ "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
		{ "n", "grt", vim.lsp.buf.type_definition, "Go to *type* definition" },
		{
			"n",
			"gq",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"Format buffer (async)",
		},
	},

	-------------------------------------------------------------------------------
	-- Os keymaps abaixo já são criados automaticamente pelo Neovim 0.12          --
	-- quando um LSP é anexado. Mantidos aqui apenas como referência/documentação. --
	-------------------------------------------------------------------------------
	-- { "n", "grn", vim.lsp.buf.rename,            "Rename symbol" },
	-- { "n", "gra", vim.lsp.buf.code_action,       "Code actions"  },
	-- { "n", "grr", vim.lsp.buf.references,        "Find references" },
	-- { "n", "gri", vim.lsp.buf.implementation,    "Find implementations" },
	-- { "n", "[d",  vim.diagnostic.goto_prev,      "Prev diagnostic" },
	-- { "n", "]d",  vim.diagnostic.goto_next,      "Next diagnostic" },
	-- { "n", "K",   vim.lsp.buf.hover,             "Hover docs" },
	-- { "n", "<C-w>d", vim.diagnostic.open_float,  "Line diagnostics (float)" },
	-- { "n", "<C-o>", {}, "Go back from definition"}
}
