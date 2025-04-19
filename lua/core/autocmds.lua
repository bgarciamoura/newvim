local vim = vim

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- LSP Inlay hints --
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    -- LSP Highlight --
    if client:supports_method("textDocument/documentHighlight") then
      local autocmd = vim.api.nvim_create_autocmd
      local augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })

      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup })

      autocmd({ "CursorHold" }, {
        group = augroup,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      autocmd({ "CursorMoved" }, {
        group = augroup,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end



    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- Ativar floating window for diagnostic
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if vim.fn.mode() == "n" then
      vim.diagnostic.open_float(nil, { focus = false })
    end
  end,
})

-- Ativar virtual text
vim.api.nvim_create_user_command('EnableVirtualText', function()
  vim.diagnostic.config({ virtual_text = true })
end, {})

-- Desativar virtual text
vim.api.nvim_create_user_command('DisableVirtualText', function()
  vim.diagnostic.config({ virtual_text = false })
end, {})
