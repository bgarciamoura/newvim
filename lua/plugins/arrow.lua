return {
    "otavioschwanck/arrow.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        require("arrow").setup({
            show_icons = true,
            leader_key = "<leader>a",
        })
    end,
}
