-- OpenKore config.txt filetype plugin
-- Enable gcc commenting support and specific settings

-- Set comment string for gcc commenting (using # as default)
vim.bo.commentstring = "# %s"

-- OpenKore config-specific settings
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- Enable folding on braces and blocks
vim.wo.foldmethod = "syntax"
vim.wo.foldlevel = 99

-- Auto-detect file format instead of forcing unix format

-- Enable spell checking for comments only
vim.wo.spell = false
vim.bo.spelllang = "en_us"