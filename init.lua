-- Neovim 0.12 configuration optimized for Windows Terminal + Nushell + Jupyter
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")
require("core.lsp")
require("core.python")
require("core.jupyter")

-- Set colorscheme with fallback
local function safe_colorscheme(scheme)
    local ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)
    if not ok then
        vim.cmd("colorscheme habamax")
    end
end

vim.schedule(function()
    safe_colorscheme("nightfly")
end)