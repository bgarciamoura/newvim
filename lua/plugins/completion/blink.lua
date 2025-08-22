return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  build = function()
    -- Only build if cargo is available
    if vim.fn.executable("cargo") == 1 then
      if vim.fn.has("win32") == 1 then
        return "powershell -Command \"cargo build --release\""
      else
        return "cargo build --release"
      end
    else
      vim.notify("Cargo not found. blink.cmp will use fallback mode.", vim.log.levels.WARN)
      return nil
    end
  end,
  opts = {
    keymap = { preset = "default" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono"
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = -3,
          opts = {
            get_bufnrs = function()
              return vim
                .iter(vim.api.nvim_list_wins())
                :map(function(win)
                  return vim.api.nvim_win_get_buf(win)
                end)
                :filter(function(buf)
                  return vim.bo[buf].buftype ~= "nofile"
                end)
                :totable()
            end,
          },
        },
      }
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
      },
      ghost_text = {
        enabled = true,
      },
    },
    signature = {
      enabled = true,
    },
  },
  opts_extend = { "sources.default" }
}