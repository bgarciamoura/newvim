return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  opts = function()
    return {
      diagnostics = {
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
      },
      inlay_hints = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        lua_ls = {
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
        -- TypeScript/JavaScript LSP
        ts_ls = {
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
              },
              preferences = {
                includePackageJsonAutoImports = "auto",
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
              },
              preferences = {
                includePackageJsonAutoImports = "auto",
              },
            },
          },
        },
        -- ESLint LSP
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            experimental = {
              useFlatConfig = true,
            },
          },
          on_attach = function(client, bufnr)
            -- Only set up auto-fix if ESLint is properly configured
            if client.server_capabilities.executeCommandProvider then
              -- Check if EslintFixAll command is available
              local commands = client.server_capabilities.executeCommandProvider.commands or {}
              local has_eslint_fix = false
              for _, cmd in ipairs(commands) do
                if cmd == "eslint.executeAutofix" then
                  has_eslint_fix = true
                  break
                end
              end
              
              if has_eslint_fix then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    local params = {
                      command = "eslint.executeAutofix",
                      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
                    }
                    local result = vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 1000)
                    if not result or vim.tbl_isempty(result) then
                      -- Silently handle case where ESLint fix fails
                      vim.notify("ESLint auto-fix not available for this file", vim.log.levels.DEBUG)
                    end
                  end,
                })
              else
                vim.notify("ESLint server started but auto-fix commands not available", vim.log.levels.WARN)
              end
            end
          end,
        },
        -- TailwindCSS LSP
        tailwindcss = {
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
        },
        -- Biome LSP configuration
        biome = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            local root_files = { "biome.json", "biome.jsonc" }
            
            -- Try to find Biome config files
            local root = util.root_pattern(unpack(root_files))(fname)
            if root then
              return root
            end
            
            -- Fallback to package.json if it contains biome config
            local package_json_root = util.root_pattern("package.json")(fname)
            if package_json_root then
              local package_json_path = package_json_root .. "/package.json"
              if vim.fn.filereadable(package_json_path) == 1 then
                local ok, package_content = pcall(vim.fn.readfile, package_json_path)
                if ok and type(package_content) == "table" then
                  local content = table.concat(package_content, "\n")
                  if content:match('"@biomejs/biome"') or content:match('"biome"') then
                    return package_json_root
                  end
                end
              end
            end
            
            -- Final fallback to git root or current directory
            return util.find_git_ancestor(fname) or vim.fn.getcwd()
          end,
        },
      },
    }
  end,
  config = function(_, opts)
    -- Setup diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    -- Setup completion
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("blink.cmp").get_lsp_capabilities(),
      opts.capabilities or {}
    )
    -- Setup servers
    local function setup_server(server_name, server_opts)
      server_opts = server_opts or {}
      server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})

      -- Add LSP keymaps
      server_opts.on_attach = function(client, bufnr)
        require("core.lsp-keymaps").on_attach(client, bufnr)
        if server_opts.on_attach then
          server_opts.on_attach(client, bufnr)
        end
      end

      if server_opts.setup then
        server_opts.setup(server_name, server_opts)
      else
        require("lspconfig")[server_name].setup(server_opts)
      end
    end

    -- Auto-install and setup servers
    local servers = opts.servers or {}
    local ensure_installed = vim.tbl_keys(servers)

    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
      handlers = {
        function(server_name)
          setup_server(server_name, servers[server_name])
        end,
      },
    })
  end,
}
