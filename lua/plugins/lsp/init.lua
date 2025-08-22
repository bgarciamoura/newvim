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
