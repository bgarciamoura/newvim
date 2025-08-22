return {
  "DaikyXendo/nvim-material-icon",
  lazy = true,
  opts = {
    override = {},
    color_icons = true,
    default = true,
  },
  config = function(_, opts)
    require("nvim-web-devicons").setup(opts)
  end,
}