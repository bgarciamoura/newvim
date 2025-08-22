return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer" },
  keys = {
    { "<leader>uc", "<cmd>ColorizerToggle<cr>", desc = "Toggle colorizer" },
  },
  opts = {
    filetypes = {
      "css",
      "scss",
      "sass",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "lua",
      "vim",
      "toml",
      "yaml",
      "json",
    },
    user_default_options = {
      RGB = true,      -- #RGB hex codes
      RRGGBB = true,   -- #RRGGBB hex codes
      names = true,    -- "Name" codes like Blue or blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = true, -- 0xAARRGGBB hex codes
      rgb_fn = true,   -- CSS rgb() and rgba() functions
      hsl_fn = true,   -- CSS hsl() and hsla() functions
      css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
      mode = "background", -- Set the display mode: foreground, background, virtualtext
      tailwind = true, -- Enable tailwind colors
      sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
      virtualtext = "■",
      always_update = false
    },
    buftypes = {},
  },
  config = function(_, opts)
    require("colorizer").setup(opts.filetypes, opts.user_default_options)
  end,
}