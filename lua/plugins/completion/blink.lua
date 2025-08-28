return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = '1.*',
    dependencies = {
      "L3MON4D3/LuaSnip", -- se quiser snippets
    },
    config = function()
      local blink = require("blink.cmp")

      blink.setup({
        keymap = {
          preset = "default", -- ou "super-tab"
        },
        sources = {
          -- ativa integração com LSP
          default = { "lsp", "path", "buffer" },
        },
        completion = {
          documentation = { auto_show = true },
          menu = { border = "rounded" },
        },
      })
    end,
  },
}

