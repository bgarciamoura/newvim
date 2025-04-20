---@diagnostic disable-next-line: undefined-global
local vim = vim

require("core.options")
require("core.diagnostics")
require("core.autocmds")
require("core.lazy")

local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"
for _, file in ipairs(vim.fn.readdir(lsp_dir, [[v:val =~ '\.lua$']])) do
	local module_name = file:sub(1, -5) -- Remove '.lua' da extensão
	require("lsp." .. module_name)
end

vim.lsp.inlay_hint.enable()
vim.cmd("colorscheme kanagawa")
