vim.lsp.config["cssmodulesls"] = {
  cmd = { 'cssmodules-language-server' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { "package.json" }
}

vim.lsp.enable("cssmodulesls")
