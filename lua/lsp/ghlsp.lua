vim.lsp.config['gh_actions_ls'] = {
  cmd = { 'gh-actions-language-server', '--stdio' },
  filetypes = { 'yaml.github' },
  root_markers = { '.github' },
  single_file_support = true,
  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },
}

vim.filetype.add({
  pattern = {
    ['.*/%.github/workflows/.*%.ya?ml'] = 'yaml.github',
  },
})


vim.lsp.enable('gh_actions_ls')
