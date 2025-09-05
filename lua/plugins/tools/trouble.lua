return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Workspace)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (Buffer)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
  },
  opts = {
    use_diagnostic_signs = true,
  },
}
