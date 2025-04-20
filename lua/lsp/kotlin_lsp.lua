vim.lsp.config['kotlin_language_server'] = {
  cmd = { 'kotlin-language-server' },
  filetypes = { 'kotlin', 'kts' },
  root_markers = { 'settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts', '.git' },
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = "1.8"
        }
      },
      completion = {
        snippets = {
          enabled = true
        }
      },
      debugAdapter = {
        enabled = false
      },
      externalSources = {
        autoConvertToKotlin = true,
        useKlsScheme = true
      }
    }
  }
}

vim.lsp.enable('kotlin_language_server')
