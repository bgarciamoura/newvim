vim.lsp.config['bashls'] = {
  cmd = { 'bash-language-server', 'start' },
  settings = {
    bashIde = {
      globPattern = '*@(.sh|.inc|.bash|.command)',
    },
  },
  filetypes = { 'sh', 'bash' },
  root_markers = { '.git' },
  single_file_support = true,
}

vim.lsp.enable("bashls")
