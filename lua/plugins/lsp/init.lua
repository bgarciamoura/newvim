return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    -- Configuração de diagnósticos
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪",
          [vim.diagnostic.severity.HINT] = "󰌶",
          [vim.diagnostic.severity.INFO] = "󰋽",
        },
      },
    })

    -- Capabilities para blink.cmp
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("blink.cmp").get_lsp_capabilities()
    )

    -- Configuração padrão para servidores
    local default_setup = function(server)
      require("lspconfig")[server].setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Anexar keymaps LSP
          require("core.lsp-keymaps").on_attach(client, bufnr)

          -- Ativar inlay hints se suportado
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })
    end

    -- Configuração do mason-lspconfig
    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",           -- TypeScript
        "lua_ls",          -- Lua
        "tailwindcss",     -- TailwindCSS
      },
      automatic_installation = true,
      handlers = {
        -- Handler padrão
        default_setup,

        -- Configurações específicas
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              require("core.lsp-keymaps").on_attach(client, bufnr)
              if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              end
            end,
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          })
        end,

        ["ts_ls"] = function()
          require("lspconfig").ts_ls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              require("core.lsp-keymaps").on_attach(client, bufnr)
              if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              end
            end,
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
          })
        end,

        ["tailwindcss"] = function()
          require("lspconfig").tailwindcss.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              require("core.lsp-keymaps").on_attach(client, bufnr)
            end,
            settings = {
              tailwindCSS = {
                experimental = {
                  classRegex = {
                    { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                    { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  },
                },
                validate = true,
                lint = {
                  cssConflict = "warning",
                  invalidApply = "error",
                  invalidConfigPath = "error",
                  invalidScreen = "error",
                  invalidTailwindDirective = "error",
                  invalidVariant = "error",
                  recommendedVariantOrder = "warning",
                },
                classAttributes = {
                  "class",
                  "className", 
                  "class:list",
                  "classList",
                  "ngClass",
                },
              },
            },
          })
        end,
      },
    })
  end,
}