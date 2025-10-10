-- Compatibility layer for vim.fs API changes in Neovim 0.12+
-- This fixes the issue where vim.fs.root() returns a table instead of string
local M = {}

-- Store original functions
local original_fs_root = vim.fs.root
local original_fs_find = vim.fs.find

-- Wrapper for vim.fs.root that ensures it always returns string or nil
function M.root(source, marker)
	local result = original_fs_root(source, marker)

	-- Handle table return (Neovim 0.12+)
	if type(result) == "table" then
		if #result > 0 then
			return result[1]
		else
			return nil
		end
	end

	return result
end

-- Wrapper for vim.fs.find that ensures paths are strings
function M.find(names, opts)
	-- Normalize opts.path to always be a string
	if opts and opts.path then
		if type(opts.path) == "table" then
			opts.path = opts.path[1] or vim.loop.cwd()
		end
	end

	local result = original_fs_find(names, opts)
	return result
end

-- Apply patches globally
function M.setup()
	-- Override vim.fs functions globally
	vim.fs.root = M.root
	vim.fs.find = M.find

	-- Also patch vim.fs._original for safety
	vim.fs._original_root = original_fs_root
	vim.fs._original_find = original_fs_find
end

return M
