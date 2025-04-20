vim.lsp.config["postgresls"] = {
  cmd = { 'postgrestools', 'lsp-proxy' },
  filetypes = {
    'sql',
  },
  root_markers = { 'postgrestools.jsonc' }
}

vim.lsp.enable("postgresls")
