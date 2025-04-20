return {
  "williamboman/mason.nvim",
  priority = 1001,
  config = function()
    require("mason").setup({})
  end
}
