return {
	event = "LspAttach", -- Será aplicado quando um LSP se conectar
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
		{ "n", "<leader>l", ":checkhealth vim.lsp<cr>", "Checa o estado dos LSPs", { silent = true } },
		{
			"i",
			"<C-Space>",
			function()
				-- Não precisamos mais disso com blink.cmp
				-- vim.lsp.completion.get()
			end,
			"Completação já gerenciada pelo blink.cmp",
		},

		-- ===== CODE ACTIONS =====
		{
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			"Code Actions",
		},
		{
			"v",
			"<leader>ca",
			vim.lsp.buf.code_action,
			"Code Actions (Visual)",
		},

		-- ===== RENAME =====
		{
			"n",
			"<leader>rn",
			vim.lsp.buf.rename,
			"Rename Symbol",
		},

		-- ===== ORGANIZE IMPORTS (para TypeScript) =====
		{
			"n",
			"<leader>oi",
			function()
				vim.lsp.buf.execute_command({
					command = "typescript.organizeImports",
					arguments = { vim.uri_from_bufnr(0) },
				})
			end,
			"Organize Imports (TypeScript)",
		},

		-- ===== REMOVE UNUSED IMPORTS (para TypeScript) =====
		{
			"n",
			"<leader>ru",
			function()
				vim.lsp.buf.execute_command({
					command = "typescript.removeUnused",
					arguments = { vim.uri_from_bufnr(0) },
				})
			end,
			"Remove Unused Imports (TypeScript)",
		},

		-- ===== ADD MISSING IMPORTS (para TypeScript) =====
		{
			"n",
			"<leader>ai",
			function()
				vim.lsp.buf.execute_command({
					command = "typescript.addMissingImports",
					arguments = { vim.uri_from_bufnr(0) },
				})
			end,
			"Add Missing Imports (TypeScript)",
		},
	},

	-------------------------------------------------------------------------------
	-- Os keymaps abaixo já são criados automaticamente pelo Neovim 0.12          --
	-- quando um LSP é anexado. Mantidos aqui apenas como referência/documentação. --
	-------------------------------------------------------------------------------
	-- { "n", "grn", vim.lsp.buf.rename,            { desc = "Rename symbol" } },
	-- { "n", "gra", vim.lsp.buf.code_action,       { desc = "Code actions" } },
	-- { "n", "grr", vim.lsp.buf.references,        { desc = "Find references" } },
	-- { "n", "gri", vim.lsp.buf.implementation,    { desc = "Find implementations" } },
	-- { "n", "[d",  vim.diagnostic.goto_prev,      { desc = "Prev diagnostic" } },
	-- { "n", "]d",  vim.diagnostic.goto_next,      { desc = "Next diagnostic" } },
	-- { "n", "K",   vim.lsp.buf.hover,             { desc = "Hover docs" } },
	-- { "n", "<C-w>d", vim.diagnostic.open_float,  { desc = "Line diagnostics (float)" } },
	-- { "n", "<C-o>", {}, { desc = "Go back from definition" } },
}
