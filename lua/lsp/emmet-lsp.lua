vim.lsp.config["emmet_lsp"] = {
    cmd = { 'emmet-ls', '--stdio' },
    filetypes = {
      'astro',
      'css',
      'eruby',
      'html',
      'htmldjango',
      'javascriptreact',
      'less',
      'pug',
      'sass',
      'scss',
      'svelte',
      'typescriptreact',
      'vue',
      'htmlangular',
    },
    root_markers = { ".git" }
}

vim.lsp.enable("emmet_lsp")
