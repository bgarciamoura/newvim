return {
  "romek-codes/bruno.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim", 
    "nvim-telescope/telescope.nvim" 
  },
  cmd = { "BrunoRun", "BrunoEnv", "BrunoSearch", "BrunoToggleFormat" },
  ft = "bruno",
  keys = {
    { "<leader>br", "<cmd>BrunoRun<cr>", desc = "Run Bruno Request" },
    { "<leader>bE", "<cmd>BrunoEnv<cr>", desc = "Select Bruno Environment" },
    { "<leader>bs", "<cmd>BrunoSearch<cr>", desc = "Search Bruno Files" },
    { "<leader>bf", "<cmd>BrunoToggleFormat<cr>", desc = "Toggle Bruno Format" },
    { "<leader>bc", function() vim.cmd("BrunoRun " .. vim.fn.expand("%:p")) end, desc = "Run Current File" },
  },
  opts = {
    collection_paths = {
      -- Adicione seus caminhos de coleções Bruno aqui:
      -- { name = "Main", path = "C:/Users/bgarciamoura/Documents/Bruno" },
    },
    show_formatted_output = true,
    suppress_formatting_errors = false,
    timeout = 30000, -- Windows-friendly timeout
  },
  config = function(_, opts)
    require("bruno").setup(opts)
    
    -- Buffer-specific mappings for .bru files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "bruno",
      group = vim.api.nvim_create_augroup("BrunoBuffer", { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        
        -- Quick run with Enter
        vim.keymap.set("n", "<CR>", "<cmd>BrunoRun<cr>", { 
          buffer = bufnr, 
          desc = "Run Bruno Request" 
        })
        
        -- Environment selection then run
        vim.keymap.set("n", "<leader><CR>", function()
          vim.cmd("BrunoEnv")
          vim.defer_fn(function() vim.cmd("BrunoRun") end, 100)
        end, { 
          buffer = bufnr, 
          desc = "Select Environment & Run" 
        })
        
        -- Set buffer options
        vim.bo[bufnr].commentstring = "# %s"
        vim.bo[bufnr].textwidth = 80
      end,
    })
    
    -- Load Telescope extension if available
    pcall(function()
      require("telescope").load_extension("bruno")
    end)
  end,
}