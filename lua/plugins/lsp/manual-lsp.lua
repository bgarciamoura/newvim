-- Alternative: Manual vim.lsp.start() Implementation
-- Maximum control, minimal dependencies

return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    -- ============================================================================
    -- 1. DIAGNOSTIC CONFIGURATION
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
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚",
          [vim.diagnostic.severity.WARN] = "󰀪", 
          [vim.diagnostic.severity.HINT] = "󰌶",
          [vim.diagnostic.severity.INFO] = "󰋽",
        },
      },
    })

    -- ============================================================================
    -- 2. UTILITIES
    -- ============================================================================
    local function get_capabilities()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, blink_capabilities)
      
      capabilities.workspace = capabilities.workspace or {}
      capabilities.workspace.fileOperations = {
        didRename = true,
        willRename = true,
      }
      
      return capabilities
    end

    local function safe_root_dir(patterns, fname)
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

    -- ============================================================================
    -- 3. LSP CLIENT CONFIGURATIONS
    -- ============================================================================
    local server_configs = {
      ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        name = "ts_ls",
        filetypes = { 
          "javascript", "javascriptreact", "javascript.jsx",
          "typescript", "typescriptreact", "typescript.tsx"
        },
        root_patterns = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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
      },

      eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        name = "eslint",
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx",
          "typescript", "typescriptreact", "typescript.tsx",
          "vue", "svelte"
        },
        root_patterns = {
          ".eslintrc", ".eslintrc.js", ".eslintrc.cjs",
          ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json",
          "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
          "package.json", ".git"
        },
        settings = {
          workingDirectories = { mode = "auto" },
          experimental = {
            useFlatConfig = true,
          },
        },
        on_attach = function(client, bufnr)
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
      },

      tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        name = "tailwindcss",
        filetypes = {
          "html", "css", "scss",
          "javascript", "javascriptreact", 
          "typescript", "typescriptreact",
          "vue", "svelte"
        },
        root_patterns = {
          "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts",
          "postcss.config.js", "postcss.config.cjs", "postcss.config.mjs", "postcss.config.ts",
          "package.json", ".git"
        },
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
              "class", "className", "class:list", "classList", "ngClass",
            },
          },
        },
      },

      lua_ls = {
        cmd = { "lua-language-server" },
        name = "lua_ls", 
        filetypes = { "lua" },
        root_patterns = {
          ".luarc.json", ".luarc.jsonc", ".luacheckrc",
          ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml",
          ".git"
        },
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
      },
    }

    -- ============================================================================
    -- 4. LSP CLIENT STARTER FUNCTION
    -- ============================================================================
    local function start_lsp_client(server_name, bufnr)
      local config = server_configs[server_name]
      if not config then
        return
      end

      local buf_ft = vim.bo[bufnr].filetype
      if not vim.tbl_contains(config.filetypes, buf_ft) then
        return
      end

      -- Check if client is already running for this buffer
      local clients = vim.lsp.get_clients({ name = config.name, bufnr = bufnr })
      if #clients > 0 then
        return
      end

      local fname = vim.api.nvim_buf_get_name(bufnr)
      local root_dir = safe_root_dir(config.root_patterns, fname)

      -- Build complete client config
      local client_config = {
        cmd = config.cmd,
        name = config.name,
        root_dir = root_dir,
        capabilities = get_capabilities(),
        init_options = config.init_options,
        settings = config.settings,
        on_attach = function(client, attach_bufnr)
          -- Attach keymaps
          require("core.lsp-keymaps").on_attach(client, attach_bufnr)
          
          -- Enable inlay hints
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = attach_bufnr })
          end

          -- Call server-specific on_attach
          if config.on_attach then
            config.on_attach(client, attach_bufnr)
          end
        end,
      }

      -- Start the client
      vim.lsp.start(client_config)
    end

    -- ============================================================================
    -- 5. AUTO-START LSP CLIENTS
    -- ============================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*", 
      callback = function(args)
        local bufnr = args.buf
        local filetype = vim.bo[bufnr].filetype

        -- Determine which servers to start based on filetype
        local servers_to_start = {}
        
        if filetype:match("javascript") or filetype:match("typescript") then
          servers_to_start = { "ts_ls", "eslint", "tailwindcss" }
        elseif filetype == "lua" then
          servers_to_start = { "lua_ls" }
        elseif filetype:match("html") or filetype:match("css") or filetype:match("vue") or filetype:match("svelte") then
          servers_to_start = { "tailwindcss" }
        end

        -- Start each required server
        for _, server_name in ipairs(servers_to_start) do
          start_lsp_client(server_name, bufnr)
        end
      end,
    })

    -- ============================================================================
    -- 6. MASON INTEGRATION
    -- ============================================================================
    local mason_registry = require("mason-registry")
    
    local servers_to_install = {
      "typescript-language-server",
      "eslint-lsp",
      "tailwindcss-language-server", 
      "lua-language-server",
    }

    for _, server in ipairs(servers_to_install) do
      if not mason_registry.is_installed(server) then
        local package = mason_registry.get_package(server)
        if package then
          package:install()
        end
      end
    end
  end,
}