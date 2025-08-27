-- ===================================================================
-- NATIVE NEOVIM LSP CONFIGURATION (0.11+)
-- TPope Expert Solution - Eliminates root_dir crashes completely
-- ===================================================================

return {
  "williamboman/mason.nvim",
  dependencies = {
    "saghen/blink.cmp",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- ===================================================================
    -- SAFE ROOT DIRECTORY DETECTION - Never crashes, proper type checking
    -- ===================================================================
    local function safe_root_dir(patterns, fname)
      fname = fname or vim.api.nvim_buf_get_name(0)
      
      -- Handle edge cases
      if not fname or fname == "" or fname == "[No Name]" then
        return vim.uv.cwd() or vim.fn.getcwd()
      end
      
      -- Ensure fname is a string
      if type(fname) ~= "string" then
        return vim.uv.cwd() or vim.fn.getcwd()
      end
      
      -- Get directory of the file
      local file_dir = vim.fs.dirname(fname)
      if not file_dir or type(file_dir) ~= "string" then
        return vim.uv.cwd() or vim.fn.getcwd()
      end
      
      -- Find root files
      local found_files = vim.fs.find(patterns, {
        path = file_dir,
        upward = true,
        type = "file"
      })
      
      -- Check if we found any files
      if found_files and #found_files > 0 then
        local root_file = found_files[1]
        if root_file and type(root_file) == "string" then
          local root_dir = vim.fs.dirname(root_file)
          if root_dir and type(root_dir) == "string" then
            return root_dir
          end
        end
      end
      
      -- Fallback to file directory
      return file_dir
    end

    -- ===================================================================
    -- DIAGNOSTICS CONFIGURATION
    -- ===================================================================
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

    -- ===================================================================
    -- LSP CAPABILITIES FOR BLINK.CMP
    -- ===================================================================
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("blink.cmp").get_lsp_capabilities()
    )

    -- ===================================================================
    -- NATIVE LSP SERVER CONFIGURATIONS
    -- ===================================================================

    -- TypeScript Language Server
    vim.lsp.config.ts_ls = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact", 
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
      },
      root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      root_dir = function(fname)
        return safe_root_dir({ "tsconfig.json", "jsconfig.json", "package.json", ".git" }, fname)
      end,
      capabilities = capabilities,
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
    }

    -- Lua Language Server
    vim.lsp.config.lua_ls = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
      root_dir = function(fname)
        return safe_root_dir({ ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" }, fname)
      end,
      capabilities = capabilities,
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
    }

    -- TailwindCSS Language Server
    vim.lsp.config.tailwindcss = {
      cmd = { "tailwindcss-language-server", "--stdio" },
      filetypes = {
        "html", "css", "scss", "javascript", "javascriptreact", 
        "typescript", "typescriptreact", "vue", "svelte"
      },
      root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts", ".git" },
      root_dir = function(fname)
        return safe_root_dir({ "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts", ".git" }, fname)
      end,
      capabilities = capabilities,
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
    }

    -- ===================================================================
    -- LSP ATTACHMENT AND KEYMAPS
    -- ===================================================================
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- Block Biome if it somehow gets through
        if client and client.name == "biome" then
          vim.lsp.stop_client(client.id, true)
          vim.notify("Biome LSP blocked - using ESLint + Prettier instead", vim.log.levels.WARN)
          return
        end

        -- Attach LSP keymaps
        require("core.lsp-keymaps").on_attach(client, bufnr)

        -- Enable inlay hints if supported
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })

    -- ===================================================================
    -- ENABLE LSP SERVERS FOR FILETYPES
    -- ===================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      callback = function(event)
        vim.lsp.enable("ts_ls", event.buf)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua" },
      callback = function(event)
        vim.lsp.enable("lua_ls", event.buf)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      callback = function(event)
        vim.lsp.enable("tailwindcss", event.buf)
      end,
    })

    -- ===================================================================
    -- MASON SETUP (for automatic tool installation)
    -- ===================================================================
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    -- Auto-install LSP servers
    local tools_to_install = {
      "typescript-language-server",
      "lua-language-server", 
      "tailwindcss-language-server",
      "prettier",
      "eslint_d",
      "stylua",
    }

    local registry = require("mason-registry")
    for _, tool in ipairs(tools_to_install) do
      local package = registry.get_package(tool)
      if not package:is_installed() then
        package:install()
      end
    end
  end,
}