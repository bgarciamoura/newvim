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
      javascript = { { "biome", "eslint_d" }, "prettier" },
      javascriptreact = { { "biome", "eslint_d" }, "prettier" },
      typescript = { { "biome", "eslint_d" }, "prettier" },
      typescriptreact = { { "biome", "eslint_d" }, "prettier" },
      vue = { { "biome", "eslint_d" }, "prettier" },
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
        condition = function(self, ctx)
          -- Only use biome if config files exist
          local root = vim.fs.dirname(vim.fs.find({ "biome.json", "biome.jsonc" }, { 
            path = ctx.filename, 
            upward = true 
          })[1])
          return root ~= nil
        end,
      },
      eslint_d = {
        command = "eslint_d",
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
        condition = function(self, ctx)
          -- Use eslint_d if eslint config exists and biome doesn't
          local has_biome = vim.fs.dirname(vim.fs.find({ "biome.json", "biome.jsonc" }, { 
            path = ctx.filename, 
            upward = true 
          })[1]) ~= nil
          
          if has_biome then return false end
          
          local eslint_configs = {
            ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", 
            ".eslintrc.json", ".eslintrc", "eslint.config.js"
          }
          local root = vim.fs.dirname(vim.fs.find(eslint_configs, { 
            path = ctx.filename, 
            upward = true 
          })[1])
          return root ~= nil
        end,
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