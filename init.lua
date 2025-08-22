---@diagnostic disable-next-line: undefined-global
local vim = vim

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")

vim.cmd("colorscheme aura-dark")

-- Configura os highlights do cmp após aplicar o tema
--vim.api.nvim_create_autocmd("ColorScheme", {
--	callback = function()
--		require("core.cmp-highlights").setup()
--	end,
--})

-- Ativa os highlights no início
--require("core.cmp-highlights").setup()
