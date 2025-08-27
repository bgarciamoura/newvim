return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    -- Auto-install ferramentas necessárias
    local registry = require("mason-registry")
    local tools_to_install = {
      -- LSP Servers (gerenciados pelo mason-lspconfig)
      "typescript-language-server",
      "lua-language-server",
      "tailwindcss-language-server",
      
      -- Formatters
      "prettier",
      "stylua",
      
      -- Linters
      "eslint_d",
      
      -- Debug Adapters
      "node-debug2-adapter",
    }

    for _, tool in ipairs(tools_to_install) do
      local package = registry.get_package(tool)
      if not package:is_installed() then
        package:install()
      end
    end
  end,
}