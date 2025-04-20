vim.lsp.config['terraformls'] = {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform', 'terraform-vars' },
  root_markers = { '.terraform', '.git' },
  init_options = {
    experimentalFeatures = {
      prefillRequiredFields = true,
    },
  },
}

vim.lsp.enable('terraformls')
