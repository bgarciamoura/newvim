if not vim.lsp.config then
  vim.lsp.config = {}
end

vim.lsp.config['kotlin_language_server'] = {
  cmd = { 'kotlin-language-server' },
  filetypes = { 'kotlin', 'kts' },
  root_markers = { 
    'settings.gradle', 
    'settings.gradle.kts', 
    'build.gradle', 
    'build.gradle.kts', 
    '.git' 
  },
  single_file_support = false,  -- Kotlin geralmente requer contexto de projeto
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = "1.8"  -- ou especifique uma versão mais recente se necessário
        }
      },
      completion = {
        snippets = {
          enabled = true
        }
      },
      debugAdapter = {
        enabled = false  -- habilite se você precisar de depuração
      },
      externalSources = {
        autoConvertToKotlin = true,
        useKlsScheme = true
      },
      // Novas opções disponíveis
      linting = {
        enabled = true
      },
      formatting = {
        enabled = true
      }
    }
  },
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
  end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
  vim.lsp.enable('kotlin_language_server')
end)

if not success then
  vim.notify("Falha ao habilitar o servidor Kotlin: " .. tostring(err), vim.log.levels.ERROR)
end
