return {
	group_name = "ToggleTerm",
	group_prefix = "<leader>T",
        mappings = {
                { "n", "<leader>tt", "<cmd>ToggleTerm<CR>", "Abrir Terminal" },
                {
                        "n",
                        "<leader>tv",
                        "<cmd>ToggleTerm direction=vertical<CR>",
                        "Abrir Terminal Vertical",
                },
                {
                        "n",
                        "<leader>th",
                        "<cmd>ToggleTerm direction=horizontal<CR>",
                        "Abrir Terminal Horizontal",
                },
                { "n", "<leader>t2", "<cmd>2ToggleTerm<CR>", "Abrir Segundo Terminal" },
                {
                        "n",
                        "<leader>t2v",
                        "<cmd>2ToggleTerm direction=vertical<CR>",
                        "Segundo Terminal Vertical",
                },
                {
                        "n",
                        "<leader>t2h",
                        "<cmd>2ToggleTerm direction=horizontal<CR>",
                        "Segundo Terminal Horizontal",
                },
        },
}
