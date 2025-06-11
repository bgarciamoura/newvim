return {
  group_name = "Spectre",
  group_prefix = "<leader>s",
  mappings = {
    {
      "n",
      "<leader>ss",
      "<Cmd>Spectre<CR>",
      "Search and Replace",
    },
    {
      "n",
      "<leader>sw",
      "<Cmd>Spectre word<CR>",
      "Search and Replace Word",
    },
    {
      "v",
      "<leader>sw",
      "<Esc><Cmd>Spectre word<CR>",
      "Search and Replace Word (Visual Mode)",
    },
    {
      "n",
      "<leader>sp",
      "<Cmd>Spectre toggle_preview<CR>",
      "Toggle Preview",
    },
    {
      "n",
      "<leader>sf",
      "<Cmd>Spectre file<CR>",
      "Search in File",
    },

  }
}
