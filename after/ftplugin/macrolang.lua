-- Macrolang filetype plugin
-- Enable gcc commenting support for macrolang syntax

-- Set comment string for gcc commenting (using # as default)
vim.bo.commentstring = "# %s"

-- Additional macrolang-specific settings
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- Enable folding on braces and blocks
vim.wo.foldmethod = "syntax"
vim.wo.foldlevel = 99