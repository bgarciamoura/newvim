return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      "prettier", -- Changed from prettierd to match conform.nvim
      -- TypeScript/JavaScript LSP servers
      "typescript-language-server",
      "eslint-lsp",
      "tailwindcss-language-server",
      -- Test runners and tools (removed - not available in mason)
      -- Note: Jest and Vitest are handled by neotest adapters
      -- Debug adapters
      "node-debug2-adapter",
      "chrome-debug-adapter",
    },
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local ok, p = pcall(mr.get_package, tool)
        if ok and p and not p:is_installed() then
          p:install()
        elseif not ok then
          vim.notify("Mason package not found: " .. tool, vim.log.levels.WARN)
        end
      end
    end

    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
