return {
  "bngarren/checkmate.nvim",
  ft = "markdown",
  cmd = { "Checkmate" },
  keys = {
    { "<leader>mt", "<cmd>Checkmate toggle<cr>", desc = "Toggle Todo", ft = "markdown" },
    { "<leader>mc", "<cmd>Checkmate create<cr>", desc = "Create Todo", ft = "markdown" },
    { "<leader>mx", "<cmd>Checkmate archive<cr>", desc = "Archive Completed", ft = "markdown" },
    { "<leader>ms", "<cmd>Checkmate metadata add priority<cr>", desc = "Add Priority", ft = "markdown" },
  },
  opts = {
    -- Use default file patterns (todo.md, *.todo, etc.)
    files = {
      "todo",
      "TODO", 
      "todo.md",
      "TODO.md",
      "*.todo",
      "*.todo.md",
    },
    
    -- Essential todo states (following documentation)
    todo_states = {
      unchecked = {
        marker = "□",
        order = 1,
      },
      checked = {
        marker = "✔",
        order = 2,
      },
      -- Custom states
      in_progress = {
        marker = "◐",
        markdown = ".",
        type = "incomplete",
        order = 50,
      },
      cancelled = {
        marker = "✗",
        markdown = "c",
        type = "complete", 
        order = 100,
      },
    },
    
    -- Simple metadata
    metadata = {
      priority = {
        style = function(context)
          local value = context.value:lower()
          if value == "high" then
            return { fg = "#ff5555", bold = true }
          elseif value == "medium" then
            return { fg = "#ffb86c" }
          else
            return { fg = "#8be9fd" }
          end
        end,
        get_value = function()
          return "medium"
        end,
        choices = function()
          return { "low", "medium", "high" }
        end,
        key = "<leader>mp",
        sort_order = 10,
      },
    },
    
    -- Basic configuration
    show_todo_count = true,
    todo_count_position = "eol",
    enter_insert_after_new = true,
  },
}