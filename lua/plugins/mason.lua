return {
  "williamboman/mason.nvim",
  priority = 1000,
  config = function()
    require("mason").setup({})
  end
}
