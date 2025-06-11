return {
    group_name = "Tests",
    group_prefix = "<leader>j",
    mappings = {
        { "n", "<leader>jw", "<cmd>lua require('neotest').run.run({ jestCommand = 'pnpx jest --watch ' })<cr>", "Neotest Watch" },
        { "n", "<leader>js", "<cmd>lua require('neotest').run.stop()<cr>", "Neotest Stop" },
        { "n", "<leader>jr", "<cmd>lua require('neotest').run.run()<cr>", "Neotest Run" },
        { "n", "<leader>jf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Neotest Run File" },
        { "n", "<leader>jo", "<cmd>lua require('neotest').output.open()<cr>", "Neotest Output" },
        { "n", "<leader>ju", "<cmd>lua require('neotest').summary.toggle()<cr>", "Neotest Summary" },
        { "n", "<leader>jp", "<cmd>lua require('neotest').jump.prev({status = 'failed'})<cr>", "Neotest Jump Prev Failed" },
        { "n", "<leader>jn", "<cmd>lua require('neotest').jump.next({status = 'failed'})<cr>", "Neotest Jump Next Failed" },
    },
}
