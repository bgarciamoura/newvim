vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })
vim.keymap.set("n", "<leader>l", ":checkhealth vim.lsp<cr>", { silent = true })
vim.keymap.set("i", "<C-s>", "<esc>:w<cr>", { silent = true })
-- Autocomplete
vim.keymap.set('i', '<C-Space>', function()
  vim.lsp.completion.get()
end, { desc = 'Trigger LSP completion' })

-- Diagnosticos
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float(nil, { scope = 'line', focus = false })
end, { desc = 'Exibir diagnósticos da linha atual' })

