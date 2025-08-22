return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        -- Main leader groups
        { "<leader>b", group = "bruno/buffer", icon = { icon = "󰖟 ", color = "orange" } },
        { "<leader>c", group = "code/lsp", icon = { icon = "󰅩 ", color = "yellow" } },
        { "<leader>f", group = "file/find", icon = { icon = "󰈞 ", color = "blue" } },
        { "<leader>g", group = "git", icon = { icon = "󰊢 ", color = "red" } },
        { "<leader>m", group = "markdown/todos", icon = { icon = "󰸕 ", color = "green" } },
        { "<leader>s", group = "search", icon = { icon = "󰍉 ", color = "cyan" } },
        { "<leader>t", group = "terminal", icon = { icon = "󰆍 ", color = "purple" } },
        { "<leader>u", group = "ui/toggles", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>w", group = "workspace/windows", icon = { icon = "󰖲 ", color = "blue" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },

        -- Git subgroups
        { "<leader>gh", group = "hunks", icon = { icon = "󰊢 ", color = "red" } },

        -- Buffer operations
        { "<leader>bd", desc = "Delete buffer" },
        { "<leader>be", desc = "Buffer Explorer" },

        -- Bruno API Testing
        { "<leader>br", desc = "Run Bruno Request" },
        { "<leader>bE", desc = "Select Bruno Environment" },
        { "<leader>bs", desc = "Search Bruno Files" },
        { "<leader>bf", desc = "Toggle Bruno Format" },
        { "<leader>bc", desc = "Run Current File" },

        -- Code/LSP operations
        { "<leader>ca", desc = "Code Action" },
        { "<leader>cc", desc = "Open Claude Code" },
        { "<leader>cl", desc = "Run Codelens" },
        { "<leader>cL", desc = "Refresh Codelens" },
        { "<leader>ct", desc = "Toggle Claude Code" },
        { "<leader>cd", desc = "Line Diagnostics" },
        { "<leader>cf", desc = "Format" },
        { "<leader>cR", desc = "Rename Symbol" },

        -- File operations
        { "<leader>fb", desc = "Buffers" },
        { "<leader>fc", desc = "Find Config File" },
        { "<leader>fe", desc = "Explorer NeoTree (cwd)" },
        { "<leader>fE", desc = "Explorer NeoTree (root)" },
        { "<leader>ff", desc = "Find Files (Root Dir)" },
        { "<leader>fF", desc = "Find Files (cwd)" },
        { "<leader>fg", desc = "Find Files (git-files)" },
        { "<leader>fr", desc = "Recent Files" },
        { "<leader>fR", desc = "Recent Files (cwd)" },

        -- Git operations
        { "<leader>gc", desc = "Git Commits" },
        { "<leader>ge", desc = "Git Explorer" },
        { "<leader>gg", desc = "LazyGit" },
        { "<leader>gs", desc = "Git Status" },

        -- Git hunks
        { "<leader>ghs", desc = "Stage Hunk" },
        { "<leader>ghr", desc = "Reset Hunk" },
        { "<leader>ghS", desc = "Stage Buffer" },
        { "<leader>ghu", desc = "Undo Stage Hunk" },
        { "<leader>ghR", desc = "Reset Buffer" },
        { "<leader>ghp", desc = "Preview Hunk Inline" },
        { "<leader>ghb", desc = "Blame Line" },
        { "<leader>ghB", desc = "Blame Buffer" },
        { "<leader>ghd", desc = "Diff This" },
        { "<leader>ghD", desc = "Diff This ~" },

        -- Markdown/Todo operations (Checkmate)
        { "<leader>mt", desc = "Toggle Todo" },
        { "<leader>mc", desc = "Create Todo" },
        { "<leader>mx", desc = "Archive Completed" },
        { "<leader>ms", desc = "Add Priority" },
        { "<leader>mp", desc = "Set Priority" },

        -- Search operations
        { '<leader>s"', desc = "Registers" },
        { "<leader>sa", desc = "Auto Commands" },
        { "<leader>sb", desc = "Buffer" },
        { "<leader>sc", desc = "Command History" },
        { "<leader>sC", desc = "Commands" },
        { "<leader>sd", desc = "Document Diagnostics" },
        { "<leader>sD", desc = "Workspace Diagnostics" },
        { "<leader>sg", desc = "Grep (Root Dir)" },
        { "<leader>sG", desc = "Grep (cwd)" },
        { "<leader>sh", desc = "Help Pages" },
        { "<leader>sH", desc = "Search Highlight Groups" },
        { "<leader>sj", desc = "Jumplist" },
        { "<leader>sk", desc = "Key Maps" },
        { "<leader>sl", desc = "Location List" },
        { "<leader>sM", desc = "Man Pages" },
        { "<leader>sm", desc = "Jump to Mark" },
        { "<leader>so", desc = "Options" },
        { "<leader>sR", desc = "Resume" },
        { "<leader>sq", desc = "Quickfix List" },
        { "<leader>ss", desc = "Goto Symbol" },
        { "<leader>sS", desc = "Goto Symbol (Workspace)" },
        { "<leader>sw", desc = "Word (Root Dir)" },
        { "<leader>sW", desc = "Word (cwd)" },

        -- Terminal operations
        { "<leader>tt", desc = "Toggle Terminal" },
        { "<leader>th", desc = "Toggle Horizontal Terminal" },
        { "<leader>tv", desc = "Toggle Vertical Terminal" },
        { "<leader>tf", desc = "Toggle Float Terminal" },
        { "<leader>ld", desc = "Open Lazydocker" },

        -- UI toggles
        { "<leader>uc", desc = "Toggle Colorizer" },
        { "<leader>uC", desc = "Colorscheme with Preview" },
        { "<leader>uh", desc = "Toggle Inlay Hints" },
        { "<leader>un", desc = "Dismiss All Notifications" },
        { "<leader>us", desc = "Toggle Smear Cursor" },

        -- Workspace operations
        { "<leader>wa", desc = "Add Workspace Folder" },
        { "<leader>wr", desc = "Remove Workspace Folder" },
        { "<leader>wl", desc = "List Workspace Folders" },

        -- Navigation groups
        { "[", group = "prev", icon = { icon = "󰒮 ", color = "blue" } },
        { "]", group = "next", icon = { icon = "󰒭 ", color = "blue" } },
        { "[d", desc = "Prev Diagnostic" },
        { "]d", desc = "Next Diagnostic" },
        { "[h", desc = "Prev Hunk" },
        { "]h", desc = "Next Hunk" },
        { "[H", desc = "First Hunk" },
        { "]H", desc = "Last Hunk" },
        { "[f", desc = "Prev Function Start" },
        { "]f", desc = "Next Function Start" },
        { "[F", desc = "Prev Function End" },
        { "]F", desc = "Next Function End" },
        { "[c", desc = "Prev Class Start" },
        { "]c", desc = "Next Class Start" },
        { "[C", desc = "Prev Class End" },
        { "]C", desc = "Next Class End" },
        { "[a", desc = "Prev Parameter" },
        { "]a", desc = "Next Parameter" },
        { "[A", desc = "Prev Parameter End" },
        { "]A", desc = "Next Parameter End" },

        -- Goto operations
        { "g", group = "goto", icon = { icon = "󰉁 ", color = "yellow" } },
        { "gd", desc = "Go to Definition" },
        { "gD", desc = "Go to Declaration" },
        { "gr", desc = "Go to References" },
        { "gI", desc = "Go to Implementation" },
        { "gy", desc = "Go to Type Definition" },
        { "K", desc = "Hover" },
        { "gK", desc = "Signature Help" },

        -- Fold operations
        { "z", group = "fold", icon = { icon = "󰘖 ", color = "purple" } },

        -- Comment operations
        { "gc", group = "comment", icon = { icon = "󰅺 ", color = "green" } },
        { "gb", group = "comment block", icon = { icon = "󰅺 ", color = "green" } },
        { "gcc", desc = "Comment toggle current line" },
        { "gbc", desc = "Comment toggle current block" },

        -- Treesitter selection
        { "<C-S-space>", desc = "Increment Selection" },
        { "<bs>", desc = "Decrement Selection", mode = "x" },

        -- Quick actions
        { "<leader>,", desc = "Switch Buffer" },
        { "<leader>/", desc = "Toggle Comment / Grep" },
        { "<leader>:", desc = "Command History" },
        { "<leader><space>", desc = "Find Files (Root Dir)" },
        { "<leader>e", desc = "Explorer NeoTree (cwd)" },
        { "<leader>E", desc = "Explorer NeoTree (root)" },
        { "<leader>q", desc = "Quit" },
        { "<leader>w", desc = "Save File" },
        { "<leader>x", desc = "Save and Quit" },

        -- Window operations
        { "<C-h>", desc = "Go to Left Window" },
        { "<C-j>", desc = "Go to Lower Window" },
        { "<C-k>", desc = "Go to Upper Window" },
        { "<C-l>", desc = "Go to Right Window" },
        { "<S-h>", desc = "Prev Buffer" },
        { "<S-l>", desc = "Next Buffer" },

        -- Terminal mode navigation
        { "<C-\\>", desc = "Toggle Terminal" },

        -- Insert mode helpers
        { "<C-k>", desc = "Signature Help", mode = "i" },
        { "<C-s>", desc = "Save File", mode = { "n", "i" } },
        { "<C-z>", desc = "Undo", mode = { "n", "i" } },

        -- Visual mode operations
        { "<leader>c", desc = "Copy Selection", mode = "v" },
        { "<", desc = "Indent Left", mode = "v" },
        { ">", desc = "Indent Right", mode = "v" },
        { "<A-j>", desc = "Move Selection Down", mode = "v" },
        { "<A-k>", desc = "Move Selection Up", mode = "v" },

        -- Normal mode line movement
        { "<A-j>", desc = "Move Line Down" },
        { "<A-k>", desc = "Move Line Up" },

        -- Special keys and modes
        { "<C-a>", desc = "Select All Text" },
        { "<Esc>", desc = "Clear Search Highlighting" },

        -- Text objects
        { "ih", desc = "GitSigns Select Hunk", mode = { "o", "x" } },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}