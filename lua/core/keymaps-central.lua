local M = {}

-- Helper function to set keymaps
local function keymap(mode, lhs, rhs, opts)
	opts = opts or {}
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Spectre Keymaps (moved from plugins/tools/spectre.lua)
M.setup_spectre = function()
	local spectre = require("spectre")

	keymap("n", "<leader>S", spectre.toggle, { desc = "Spectre: toggle" })
	keymap("n", "<leader>sW", function() -- Changed from <leader>sw to resolve conflict
		spectre.open_visual({ select_word = true })
	end, { desc = "Spectre: search current word" })
	keymap("v", "<leader>sW", function() -- Changed from <leader>sw to resolve conflict
		spectre.open_visual()
	end, { desc = "Spectre: search selection" })
	keymap("n", "<leader>sp", function()
		spectre.open_file_search({ select_word = true })
	end, { desc = "Spectre: search in current file" })
end

-- Copilot Keymaps (extracted from plugins/tools/copilot.lua)
M.setup_copilot = function()
	local copilot_suggestion = require("copilot.suggestion")

	keymap("i", "<Tab>", function()
		if copilot_suggestion.is_visible() then
			copilot_suggestion.accept()
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
		end
	end, { desc = "Accept copilot suggestion or indent" })

	-- Additional Copilot keymaps (these use the panel keymap config)
	-- Panel: [[, ]], <CR>, gr, <M-CR>
	-- Suggestion: <M-w>, <M-l>, <M-]>, <M-[>, <C-]>
end

-- Bruno Keymaps are buffer-specific and handled via FileType autocmd in bruno.lua
-- Global keymaps: <leader>br, <leader>bE, <leader>bs, <leader>bf, <leader>bc
-- Buffer-specific keymaps (only in .bru files): <CR>, <leader><CR>

-- Additional Plugin Keymaps that are defined inline
M.setup_additional = function()
	-- Treesitter incremental selection (from treesitter.lua)
	-- These are typically handled by treesitter configuration, not direct keymaps

	-- GitSigns text object (from gitsigns.lua)
	-- The "ih" text object is set up in gitsigns on_attach

	-- Terminal navigation (already in core/keymaps.lua)
	-- These are properly centralized already
end

-- Initialize all keymaps
M.setup = function()
	-- Wait for plugins to load before setting up their keymaps
	vim.defer_fn(function()
		-- Only setup if plugins are available
		if pcall(require, "spectre") then
			M.setup_spectre()
		end

		if pcall(require, "copilot.suggestion") then
			M.setup_copilot()
		end

		-- Bruno keymaps are handled in the plugin via keys table and FileType autocmd
		-- No additional setup needed here

		M.setup_additional()
	end, 100) -- Small delay to ensure plugins are loaded
end

return M

