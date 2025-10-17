return {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },

  keys = {
    { "<leader>Ct", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV View", ft = { "csv", "tsv" } },
    { "<leader>Ce", "<cmd>CsvViewEnable<cr>", desc = "Enable CSV View", ft = { "csv", "tsv" } },
    { "<leader>Cd", "<cmd>CsvViewDisable<cr>", desc = "Disable CSV View", ft = { "csv", "tsv" } },
  },

  opts = {
    parser = {
      -- Lines processed per async cycle (adjust for performance)
      async_chunksize = 50,

      -- Delimiter configuration with auto-detection fallbacks
      delimiter = {
        ft = {
          csv = ",",
          tsv = "\t",
        },
        fallbacks = { ",", "\t", ";", "|", ":", " " },
      },

      -- Quote character for escaping delimiters
      quote_char = '"',

      -- Comment line prefixes
      comments = { "#", "--", "//" },

      -- Max lines to search for closing quote in multi-line fields
      max_lookahead = 50,
    },

    view = {
      -- Minimum column width
      min_column_width = 5,

      -- Space between columns
      spacing = 2,

      -- Display mode: "highlight" or "border"
      display_mode = "highlight",

      -- Header line (true = auto-detect, number = specific line, false = disable)
      header_lnum = true,

      -- Sticky header configuration
      sticky_header = {
        enabled = true,
        separator = "─",
      },
    },

    -- Custom keymaps to avoid conflicts with normal navigation
    keymaps = {
      -- Text objects (works in visual and operator-pending modes)
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },

      -- Navigation using Ctrl+arrows to avoid Tab/Enter conflicts
      jump_next_field_end = { "<C-Right>", mode = { "n", "v" } },
      jump_prev_field_end = { "<C-Left>", mode = { "n", "v" } },
      jump_next_row = { "<C-Down>", mode = { "n", "v" } },
      jump_prev_row = { "<C-Up>", mode = { "n", "v" } },
    },
  },

  config = function(_, opts)
    require("csvview").setup(opts)

    -- Auto-enable CSV view for CSV/TSV files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "csv", "tsv" },
      group = vim.api.nvim_create_augroup("CsvViewBuffer", { clear = true }),
      callback = function(event)
        local bufnr = event.buf

        -- Defer enabling to ensure buffer is fully loaded
        vim.defer_fn(function()
          -- Check if buffer is still valid
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.cmd("CsvViewEnable")
          end
        end, 100)

        -- Buffer-specific options for CSV files
        vim.bo[bufnr].commentstring = "# %s"
        vim.wo[bufnr].wrap = false -- Don't wrap long lines in CSV
        vim.wo[bufnr].linebreak = false
      end,
    })

    -- Performance warning for very large CSV files
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = { "*.csv", "*.tsv" },
      group = vim.api.nvim_create_augroup("CsvViewPerformance", { clear = true }),
      callback = function()
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count > 10000 then
          vim.notify(
            string.format(
              "CSV file has %d lines. Consider using :CsvViewDisable if performance is slow.",
              line_count
            ),
            vim.log.levels.WARN,
            { title = "CSV View" }
          )
        end
      end,
    })

    -- Optional: Show status when CSV view is toggled
    vim.api.nvim_create_autocmd("User", {
      pattern = { "CsvViewAttach", "CsvViewDetach" },
      group = vim.api.nvim_create_augroup("CsvViewStatus", { clear = true }),
      callback = function(event)
        if event.match == "CsvViewAttach" then
          vim.notify("CSV View enabled", vim.log.levels.INFO, { title = "CSV View" })
        else
          vim.notify("CSV View disabled", vim.log.levels.INFO, { title = "CSV View" })
        end
      end,
    })
  end,
}
