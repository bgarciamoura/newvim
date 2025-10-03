local M = {}

function M.on_attach(client, bufnr)
	-- Handle native LSP calls where client might be nil
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local function map(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	-- Navigation
	map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
	map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
	map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
	map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

	-- Hover and help
	map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
	map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
	map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

	-- Code actions
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
	map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run codelens" })
	map("n", "<leader>cL", vim.lsp.codelens.refresh, { desc = "Refresh & display codelens" })
	map("n", "<leader>cR", vim.lsp.buf.rename, { desc = "Rename" })

	-- Diagnostics
	map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
	map("n", "gl", function()
		vim.diagnostic.open_float(nil, { scope = "cursor" })
	end, { desc = "Mostrar diagnóstico (popup)" })
	map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
	map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
	map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Abrir LocList com diagnósticos" })

	-- Workspace
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { desc = "List workspace folders" })

	-- Toggle inlay hints (works with native LSP)
	map("n", "H", function()
		local buf = vim.api.nvim_get_current_buf()
		local ih = vim.lsp.inlay_hint or vim.lsp.buf.inlay_hint
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(buf), { bufnr = buf })
		else
			vim.lsp.buf.inlay_hint(buf, not vim.b.inlay_hints_enabled)
			vim.b.inlay_hints_enabled = not vim.b.inlay_hints_enabled
		end
	end, { desc = "Toggle inlay hints" })

	-- ESLint specific actions
	map("n", "<leader>cf", function()
		vim.lsp.buf.code_action({
			context = { only = { "source.fixAll.eslint" } },
			apply = true,
		})
	end, { desc = "ESLint fix all" })

	-- Mason management
	map("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Open Mason" })
end

return M
