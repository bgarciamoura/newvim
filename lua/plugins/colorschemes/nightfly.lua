return {
  "bluz71/vim-nightfly-colors",
  name = "nightfly",
  lazy = false,
  priority = 1000,
  config = function()
    -- Configure nightfly before loading (these are the actual supported options)
    vim.g.nightflyTransparent = true              -- Match your Kanagawa transparent preference
    vim.g.nightflyTerminalColors = true           -- Enhanced terminal integration
    vim.g.nightflyUndercurls = true              -- Modern diagnostic styling
    vim.g.nightflyCursorLine = true              -- Better cursor visibility
    vim.g.nightflyItalics = true                 -- Professional typography
    vim.g.nightflyWinSeparator = 2               -- Clean window borders
    
    -- Load the colorscheme
    vim.cmd.colorscheme("nightfly")
    
    -- Post-load refinements for your specific setup
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "nightfly",
      callback = function()
        local highlights = {
          -- Maintain transparency consistency
          Normal = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          EndOfBuffer = { bg = "NONE" },
          
          -- Neo-tree integration
          NeoTreeNormal = { bg = "NONE" },
          NeoTreeNormalNC = { bg = "NONE" },
          NeoTreeEndOfBuffer = { bg = "NONE" },
          
          -- Telescope refinements
          TelescopeNormal = { bg = "NONE" },
          TelescopePreviewNormal = { bg = "NONE" },
          TelescopePromptNormal = { bg = "NONE" },
          TelescopeResultsNormal = { bg = "NONE" },
          
          -- Blink completion styling
          BlinkCmpMenu = { bg = "#011627", blend = 90 },
          BlinkCmpMenuBorder = { fg = "#7c8f8f", bg = "NONE" },
          BlinkCmpMenuSelection = { bg = "#1d3b53" },
          BlinkCmpDoc = { bg = "#011627", blend = 90 },
          BlinkCmpDocBorder = { fg = "#7c8f8f", bg = "NONE" },
          
          -- Professional statusline (let Lualine handle colors)
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          
          -- Enhanced Tree-sitter semantics
          ["@function.builtin"] = { fg = "#82aaff", italic = true },
          ["@keyword.function"] = { fg = "#c792ea", italic = true },
          ["@type.builtin"] = { fg = "#ffcb8b" },
          ["@variable.parameter"] = { fg = "#e3d18a" },
          ["@comment"] = { fg = "#637777", italic = true },
          
          -- Refined diff colors for Git workflow
          DiffAdd = { bg = "#0b2818" },
          DiffChange = { bg = "#2c2415" },
          DiffDelete = { bg = "#2a1517" },
          DiffText = { bg = "#3c3527", bold = true },
          
          -- Git signs consistency
          GitSignsAdd = { fg = "#8cc85f", bg = "NONE" },
          GitSignsChange = { fg = "#e3d18a", bg = "NONE" },
          GitSignsDelete = { fg = "#ff5874", bg = "NONE" },
        }
        
        for group, opts in pairs(highlights) do
          vim.api.nvim_set_hl(0, group, opts)
        end
      end,
    })
  end,
}