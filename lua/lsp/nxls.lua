vim.lsp.config["nxls"] = {
  cmd = { 'nxls', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'nx.json', '.git' }
}

vim.lsp.enable("nxls")
