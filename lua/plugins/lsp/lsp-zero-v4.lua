-- Alternative: lsp-zero.nvim v4 Configuration
-- Use this if Native LSP has compatibility issues

return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v4.x",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  config = function()
    local lsp_zero = require("lsp-zero")

    -- ============================================================================
    -- 1. LSP-ZERO SETUP WITH BLINK.CMP
    -- ============================================================================
    local lsp_attach = function(client, bufnr)
      -- Attach keymaps
      require("core.lsp-keymaps").on_attach(client, bufnr)
      
      -- Enable inlay hints if supported
      if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    lsp_zero.extend_lspconfig({
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      lsp_attach = lsp_attach,
      float_border = "rounded",
      sign_text = {
        error = "󰅚",
        warn = "󰀪", 
        hint = "󰌶",
        info = "󰋽",
      },
    })

    -- ============================================================================
    -- 2. DIAGNOSTIC CONFIGURATION
    -- ============================================================================
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
    })

    -- ============================================================================
    -- 3. SAFE ROOT DIRECTORY FUNCTION
    -- ============================================================================
    local function safe_root_dir(patterns)
      return function(fname)
        fname = fname or vim.api.nvim_buf_get_name(0)
        
        if fname == "" or fname == "[No Name]" then
          return vim.loop.cwd()
        end
        
        local path = vim.fs.dirname(fname)
        local root = vim.fs.find(patterns, {
          path = path,
          upward = true,
          type = "file"
        })[1]
        
        return root and vim.fs.dirname(root) or path
      end
    end

    -- ============================================================================
    -- 4. MASON + LSPCONFIG SETUP
    -- ============================================================================
    require("mason").setup({})
    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",
        "eslint",
        "tailwindcss",
        "lua_ls",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        -- TypeScript LSP
        ts_ls = function()
          require("lspconfig").ts_ls.setup({
            root_dir = safe_root_dir({
              "tsconfig.json",
              "jsconfig.json",
              "package.json", 
              ".git"
            }),
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript", 
              "typescriptreact",
              "typescript.tsx",
            },
            init_options = {
              hostInfo = "neovim",
              preferences = {
                includePackageJsonAutoImports = "auto",
                includeCompletionsForModuleExports = true,
                includeCompletionsWithInsertText = true,
              },
            },
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                  includeCompletionsForModuleExports = true,
                  includeCompletionsWithInsertText = true,
                  includeAutomaticOptionalChainCompletions = true,
                },
                preferences = {
                  includePackageJsonAutoImports = "auto",
                  importModuleSpecifier = "relative",
                  allowTextChangesInNewFiles = true,
                },
                workspaceSymbols = {
                  scope = "allOpenProjects",
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                  includeCompletionsForModuleExports = true,
                  includeCompletionsWithInsertText = true,
                  includeAutomaticOptionalChainCompletions = true,
                },
                preferences = {
                  includePackageJsonAutoImports = "auto",
                  importModuleSpecifier = "relative",
                  allowTextChangesInNewFiles = true,
                },
              },
            },
          })
        end,

        -- ESLint LSP
        eslint = function()
          require("lspconfig").eslint.setup({
            root_dir = safe_root_dir({
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs", 
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "package.json",
              ".git"
            }),
            settings = {
              workingDirectories = { mode = "auto" },
              experimental = {
                useFlatConfig = true,
              },
            },
            on_attach = function(client, bufnr)
              -- ESLint auto-fix on save
              if client.server_capabilities.executeCommandProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    local params = {
                      command = "eslint.executeAutofix",
                      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
                    }
                    vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 1000)
                  end,
                })
              end
            end,
          })
        end,

        -- TailwindCSS LSP
        tailwindcss = function()
          require("lspconfig").tailwindcss.setup({
            root_dir = safe_root_dir({
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "postcss.config.js",
              "postcss.config.cjs", 
              "postcss.config.mjs",
              "postcss.config.ts",
              "package.json",
              ".git"
            }),
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

        -- Lua LSP
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            root_dir = safe_root_dir({
              ".luarc.json",
              ".luarc.jsonc",
              ".luacheckrc",
              ".stylua.toml",
              "stylua.toml",
              "selene.toml",
              "selene.yml", 
              ".git"
            }),
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
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
      },
    })
  end,
}