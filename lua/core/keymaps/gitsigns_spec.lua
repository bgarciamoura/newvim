return {
    group_name = "Gitsigns",
    group_prefix = "<leader>g",
    event = "BufReadPre",
    mappings = {
        { "n", "]h", function() require("gitsigns").next_hunk() end, "Next Hunk" },
        { "n", "[h", function() require("gitsigns").prev_hunk() end, "Prev Hunk" },
        { "n", "<leader>gs", function() require("gitsigns").stage_hunk() end, "Stage Hunk" },
        { "n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, "Undo Stage Hunk" },
        { "n", "<leader>gr", function() require("gitsigns").reset_hunk() end, "Reset Hunk" },
        { "n", "<leader>gp", function() require("gitsigns").preview_hunk() end, "Preview Hunk" },
        { "n", "<leader>gb", function() require("gitsigns").blame_line() end, "Blame Line" },
    },
}
