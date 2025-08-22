local M = {}

function M.on_attach(client, bufnr)
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
  map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run codelens" })
  map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & display codelens" })
  map("n", "<leader>cR", vim.lsp.buf.rename, { desc = "Rename" })

  -- Format
  map({ "n", "v" }, "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "Format" })

  -- Diagnostics
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

  -- Workspace
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List workspace folders" })

  -- Toggle inlay hints
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, { desc = "Toggle inlay hints" })
  end
end

return M
