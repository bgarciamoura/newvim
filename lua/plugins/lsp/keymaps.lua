local M = {}

function M.setup()
	-- Mapeamentos de teclas globais para LSP
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
	vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
	vim.keymap.set("n", "<leader>gq", function()
		vim.lsp.buf.format({ async = true })
	end, { desc = "Format buffer (async)" })
end

-- Inicializa o módulo
M.setup()

return M
