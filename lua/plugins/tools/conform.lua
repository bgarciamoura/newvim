return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { { "biome", "prettier" } },
      javascriptreact = { { "biome", "prettier" } },
      typescript = { { "biome", "prettier" } },
      typescriptreact = { { "biome", "prettier" } },
      vue = { { "biome", "prettier" } },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      html = { "prettier" },
      json = { { "biome", "prettier" } },
      jsonc = { { "biome", "prettier" } },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      handlebars = { "prettier" },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      php = { "php_cs_fixer" },
      sh = { "shfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters = {
      biome = {
        command = "biome",
        args = { "format", "--stdin-file-path", "$FILENAME" },
        stdin = true,
      },
      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}