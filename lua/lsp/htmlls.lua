vim.lsp.config['html'] = {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  root_markers = { '.git', 'package.json' },
  init_options = {
    configurationSection = { 'html', 'css', 'javascript' },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    provideFormatter = true,
  },
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
  end)(),
}

-- 3. Recursos Adicionais
-- Suporte a Snippets: Para que o autocompletar funcione corretamente com snippets, é necessário garantir que o cliente LSP tenha suporte a snippets ativado. Isso é feito na configuração acima com capabilities.textDocument.completion.completionItem.snippetSupport = true.​
-- GitHub
--
-- Plugins Recomendados:
--
-- Para autocompletar e snippets, considere utilizar plugins como nvim-cmp e LuaSnip.
--
-- Para fechamento automático de tags HTML, o plugin nvim-ts-autotag pode ser útil

vim.lsp.enable('html')
