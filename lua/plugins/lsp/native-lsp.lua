-- Native Neovim LSP Configuration (0.11+)
-- Replaces nvim-lspconfig to eliminate root_dir crashes

return {
  -- Remove nvim-lspconfig dependency
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
    -- 2. CAPABILITIES SETUP (BLINK.CMP INTEGRATION)
    -- ============================================================================
    local function get_capabilities()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- Blink.cmp capabilities
      local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, blink_capabilities)
      
      -- Workspace capabilities
      capabilities.workspace = capabilities.workspace or {}
      capabilities.workspace.fileOperations = {
        didRename = true,
        willRename = true,
      }
      
      return capabilities
    end

    -- ============================================================================
    -- 3. SAFE ROOT DIRECTORY DETECTION
    -- ============================================================================
    local function safe_root_dir(patterns, fname)
      fname = fname or vim.api.nvim_buf_get_name(0)
      
      -- Handle empty buffer names
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
    -- 4. NATIVE LSP SERVER CONFIGURATIONS
    -- ============================================================================
    
    -- TypeScript/JavaScript LSP
    vim.lsp.config("ts_ls", {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact", 
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_dir = function(fname)
        return safe_root_dir({
          "tsconfig.json",
          "jsconfig.json", 
          "package.json",
          ".git"
        }, fname)
      end,
      capabilities = get_capabilities(),
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

    -- ESLint LSP
    vim.lsp.config("eslint", {
      cmd = { "vscode-eslint-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx", 
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "svelte",
      },
      root_dir = function(fname)
        return safe_root_dir({
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
        }, fname)
      end,
      capabilities = get_capabilities(),
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

    -- TailwindCSS LSP  
    vim.lsp.config("tailwindcss", {
      cmd = { "tailwindcss-language-server", "--stdio" },
      filetypes = {
        "html",
        "css", 
        "scss",
        "javascript",
        "javascriptreact",
        "typescript", 
        "typescriptreact",
        "vue",
        "svelte",
      },
      root_dir = function(fname)
        return safe_root_dir({
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
        }, fname)
      end,
      capabilities = get_capabilities(),
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

    -- Lua LSP
    vim.lsp.config("lua_ls", {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_dir = function(fname)
        return safe_root_dir({
          ".luarc.json",
          ".luarc.jsonc",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "selene.yml",
          ".git"
        }, fname)
      end,
      capabilities = get_capabilities(),
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

    -- ============================================================================
    -- 5. LSP ENABLE WITH KEYMAPS
    -- ============================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "javascript", "javascriptreact", "javascript.jsx",
        "typescript", "typescriptreact", "typescript.tsx",
        "lua", "html", "css", "scss", "vue", "svelte"
      },
      callback = function(args)
        local bufnr = args.buf
        local filetype = vim.bo[bufnr].filetype
        
        -- Enable appropriate LSP servers based on filetype
        if filetype:match("javascript") or filetype:match("typescript") then
          vim.lsp.enable("ts_ls", bufnr)
          vim.lsp.enable("eslint", bufnr) 
          vim.lsp.enable("tailwindcss", bufnr)
        elseif filetype == "lua" then
          vim.lsp.enable("lua_ls", bufnr)
        elseif filetype:match("html") or filetype:match("css") or filetype:match("vue") or filetype:match("svelte") then
          vim.lsp.enable("tailwindcss", bufnr)
        end

        -- Attach keymaps
        require("core.lsp-keymaps").on_attach(nil, bufnr)
      end,
    })

    -- ============================================================================
    -- 6. INLAY HINTS CONFIGURATION
    -- ============================================================================
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })

    -- ============================================================================
    -- 7. MASON INTEGRATION (WITHOUT MASON-LSPCONFIG)
    -- ============================================================================
    local mason_registry = require("mason-registry")
    
    -- Ensure LSP servers are installed via Mason
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