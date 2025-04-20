vim.lsp.config['marksman'] = {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown' },
  root_markers = { '.git', '.marksman.toml' },
  single_file_support = true,
}

vim.lsp.enable('marksman')
