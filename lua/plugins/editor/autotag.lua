return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = true -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    per_filetype = {
      ["html"] = {
        enable_close = true
      },
      ["javascript"] = {
        enable_close = true
      },
      ["javascriptreact"] = {
        enable_close = true
      },
      ["typescript"] = {
        enable_close = true
      },
      ["typescriptreact"] = {
        enable_close = true
      },
      ["vue"] = {
        enable_close = true
      },
      ["svelte"] = {
        enable_close = true
      },
      ["xml"] = {
        enable_close = true
      }
    }
  },
  config = function(_, opts)
    require("nvim-ts-autotag").setup(opts)
  end,
}