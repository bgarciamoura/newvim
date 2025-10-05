return {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
  },
  opts = {
    -- Animação suave de slide
    stages = "fade_in_slide_out",
    -- Timeout padrão
    timeout = 3000,
    -- Posição: canto inferior direito
    top_down = false,
    -- Tamanho máximo
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.30)
    end,
    -- Ajusta zindex para não sobrepor janelas importantes
    on_open = function(win)
      vim.api.nvim_win_set_config(win, {
        zindex = 100,
        focusable = false,
      })
    end,
    -- Renderização
    render = "compact",
    -- Configurações visuais
    background_colour = "#000000",
    fps = 60,
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
    level = vim.log.levels.INFO,
    minimum_width = 30,
  },
  init = function()
    vim.notify = require("notify")
  end,
}