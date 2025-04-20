local bin_name = 'gradle-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

vim.lsp.config['gradle_ls'] = {
  cmd = { bin_name }, -- Substitua pelo caminho correto
  filetypes = { 'groovy', 'kotlin' },
  root_markers = { 'settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts' },
  settings = {
    gradle = {
      wrapper = {
        enabled = true,
      },
    },
  },
}

vim.lsp.enable('gradle_ls')
