local is_win = vim.loop.os_uname().version:match("Windows")
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
local vtsls = is_win and (mason_bin .. "vtsls.cmd") or (mason_bin .. "vtsls")

return {
  -- força stdio e evita o shim do mise usando o binário do Mason
  cmd = { vtsls, "--stdio" },

  -- filetypes padrão
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },

  -- Configurações completas para habilitar code actions e quick fixes
  settings = {
    -- Habilita completions de chamadas de função
    complete_function_calls = true,

    vtsls = {
      -- Habilita code action para mover código para arquivo
      enableMoveToFileCodeAction = true,
      -- Usa automaticamente a versão do TypeScript do workspace
      autoUseWorkspaceTsdk = true,
      -- Recursos experimentais para melhor experiência
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 50,
        },
      },
    },

    -- Configurações TypeScript
    typescript = {
      tsserver = { useSyntaxServer = "auto" },

      -- Atualiza imports automaticamente ao mover arquivos
      updateImportsOnFileMove = {
        enabled = "always"
      },

      -- Preferências para melhorar sugestões e code actions
      preferences = {
        -- Inclui auto-imports de package.json
        includePackageJsonAutoImports = "auto",
        -- Prefere imports não-relativos quando possível
        importModuleSpecifier = "shortest",
        -- Habilita snippets em sugestões
        includeCompletionsForModuleExports = true,
        -- Organiza imports automaticamente
        organizeImportsIgnoreCase = true,
        organizeImportsCollation = "unicode",
      },

      -- Sugestões de código
      suggest = {
        -- Completa chamadas de função com parâmetros
        completeFunctionCalls = true,
        -- Inclui auto-imports nas sugestões
        autoImports = true,
      },

      -- Inlay hints (dicas visuais no código)
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },

    -- Configurações JavaScript (mesmas do TypeScript)
    javascript = {
      -- Atualiza imports automaticamente ao mover arquivos
      updateImportsOnFileMove = {
        enabled = "always"
      },

      -- Preferências para melhorar sugestões e code actions
      preferences = {
        includePackageJsonAutoImports = "auto",
        importModuleSpecifier = "shortest",
        includeCompletionsForModuleExports = true,
        organizeImportsIgnoreCase = true,
        organizeImportsCollation = "unicode",
      },

      -- Sugestões de código
      suggest = {
        completeFunctionCalls = true,
        autoImports = true,
      },

      -- Inlay hints
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
  },
}
