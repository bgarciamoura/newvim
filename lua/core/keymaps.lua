local vim = vim

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Basic keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>X", "<cmd>x<cr>", { desc = "Save and quit" })
vim.keymap.set("n", "<C-s>", "<Esc>:w!<cr>", { desc = "Save file", silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w!<cr>", { desc = "Save file", silent = true })
vim.keymap.set("n", "<C-z>", "<Esc>:undo<cr>", { desc = "Undo", silent = true })
vim.keymap.set("i", "<C-z>", "<Esc>:undo<cr>", { desc = "Undo", silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection", silent = true, nowait = true })
vim.keymap.set("n", "<C-a>", "<Cmd>keepjumps normal! ggVG<CR>", { desc = "Select the entire text", silent = true })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Windows/terminal fallback: some terminals don't send <A-j>/<A-k>
vim.keymap.set("n", "<A-Down>", ":m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Terminal mode navigation
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- React/JSX specific keymaps (work with Comment.nvim)
-- Note: gcc, gc, gbc, gb are automatically provided by Comment.nvim
-- Additional useful keymaps for React development
vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Macro language syntax highlighting (moved from <leader>sm to avoid conflict with Telescope)
vim.keymap.set("n", "<leader>fM", "<cmd>set filetype=macrolang<cr>", { desc = "Set macro syntax" })

-- OpenKore config syntax highlighting
vim.keymap.set("n", "<leader>sc", "<cmd>set filetype=okconfig<cr>", { desc = "Set config syntax" })

-- Fix line endings (convert CRLF to LF)
vim.keymap.set("n", "<leader>fx", "<cmd>FixLineEndings<cr>", { desc = "Fix line endings" })

-- Tab keymaps with priority: Copilot > LuaSnip > Default
vim.keymap.set({ "i", "s" }, "<Tab>", function()
	-- 1. Check for Copilot suggestion first
	local copilot_ok, copilot_suggestion = pcall(require, "copilot.suggestion")
	if copilot_ok and copilot_suggestion.is_visible() then
		copilot_suggestion.accept()
		return
	end

	-- 2. Check for LuaSnip
	local luasnip = require("luasnip")
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
		return
	end

	-- 3. Default Tab behavior
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
end, { silent = true, desc = "Accept Copilot or expand snippet or tab" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	local luasnip = require("luasnip")
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
		return ""
	else
		return "<S-Tab>"
	end
end, { expr = true, silent = true, replace_keycodes = false, desc = "Jump backward in snippet" })

-- Python and Jupyter keymaps
local python_group = vim.api.nvim_create_augroup("PythonKeymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = python_group,
	pattern = { "python", "jupyter" },
	callback = function()
		local opts = { buffer = true, silent = true }

		-- Python environment
		vim.keymap.set(
			"n",
			"<leader>pv",
			"<cmd>PyCreateVenv<cr>",
			vim.tbl_extend("force", opts, { desc = "Create Python venv" })
		)
		vim.keymap.set(
			"n",
			"<leader>pd",
			"<cmd>PyDetectVenv<cr>",
			vim.tbl_extend("force", opts, { desc = "Detect Python venv" })
		)
		vim.keymap.set(
			"n",
			"<leader>ps",
			"<cmd>VenvSelect<cr>",
			vim.tbl_extend("force", opts, { desc = "Select Python venv" })
		)

		-- Jupyter workflow
		vim.keymap.set(
			"n",
			"<leader>js",
			"<cmd>JupyterStart<cr>",
			vim.tbl_extend("force", opts, { desc = "Start Jupyter" })
		)
		vim.keymap.set("n", "<leader>jq", "<cmd>JupyterStop<cr>", vim.tbl_extend("force", opts, { desc = "Stop Jupyter" }))

		-- Iron REPL shortcuts
		vim.keymap.set("n", "<localleader>r", function()
			local iron_ok, _ = pcall(function()
				require("iron.core").send_line()
			end)
			
			if not iron_ok then
				vim.notify("No REPL available. Run ,rs first", vim.log.levels.WARN)
			end
		end, vim.tbl_extend("force", opts, { desc = "Run line" }))
		
		vim.keymap.set("v", "<localleader>r", function()
			local iron_ok, _ = pcall(function()
				require("iron.core").visual_send()
			end)
			
			if not iron_ok then
				vim.notify("No REPL available. Run ,rs first", vim.log.levels.WARN)
			end
		end, vim.tbl_extend("force", opts, { desc = "Run selection" }))
		
		vim.keymap.set("n", "<localleader>R", function()
			local iron_ok, _ = pcall(vim.cmd, "IronRestart")
			
			if iron_ok then
				vim.notify("🔄 REPL restarted", vim.log.levels.INFO)
			else
				vim.notify("No REPL available. Run ,rs first", vim.log.levels.WARN)
			end
		end, vim.tbl_extend("force", opts, { desc = "Restart REPL" }))

		-- Execute entire cell
		vim.keymap.set("n", "<localleader>c", function()
			local line = vim.api.nvim_win_get_cursor(0)[1]
			local total_lines = vim.api.nvim_buf_line_count(0)
			local start_line = line
			local end_line = line
			
			-- Find start of cell (go up until # %% or beginning)
			while start_line > 1 do
				local content = vim.api.nvim_buf_get_lines(0, start_line - 2, start_line - 1, false)[1] or ""
				if content:match("^%s*# %%") then
					break
				end
				if content == "" and start_line < line - 5 then -- Don't go too far up for empty lines
					start_line = start_line + 1
					break
				end
				start_line = start_line - 1
			end
			
			-- Find end of cell (go down until # %% or end)
			while end_line < total_lines do
				local content = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1] or ""
				if content:match("^%s*# %%") and end_line > line then
					end_line = end_line - 1
					break
				end
				end_line = end_line + 1
			end
			
			-- Select and send the cell
			vim.api.nvim_win_set_cursor(0, {start_line, 0})
			vim.cmd("normal! V")
			vim.api.nvim_win_set_cursor(0, {end_line, 0})
			
			-- Send cell to Iron REPL
			local iron_ok, _ = pcall(function()
				require("iron.core").visual_send()
			end)
			
			if not iron_ok then
				vim.notify("No REPL available. Run ,rs first", vim.log.levels.WARN)
			end
			
			-- Return to normal mode
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
			vim.notify("📊 Cell executed", vim.log.levels.INFO)
		end, vim.tbl_extend("force", opts, { desc = "Execute cell" }))

		-- Iron REPL specific shortcuts
		vim.keymap.set("n", "<localleader>rs", function()
			pcall(vim.cmd, "IronRepl")
			vim.notify("🚀 Iron REPL started", vim.log.levels.INFO)
		end, vim.tbl_extend("force", opts, { desc = "Start REPL" }))
		
		vim.keymap.set("n", "<localleader>rf", function()
			pcall(vim.cmd, "IronFocus")
		end, vim.tbl_extend("force", opts, { desc = "Focus REPL" }))
		
		vim.keymap.set("n", "<localleader>rh", function()
			pcall(vim.cmd, "IronHide")
		end, vim.tbl_extend("force", opts, { desc = "Hide REPL" }))
		
	end,
})

-- Global Python keymaps (available in any filetype)
vim.keymap.set("n", "<leader>Pv", "<cmd>PyCreateVenv<cr>", { desc = "Create Python venv" })
vim.keymap.set("n", "<leader>Pd", "<cmd>PyDetectVenv<cr>", { desc = "Detect Python venv" })
vim.keymap.set("n", "<leader>Ps", "<cmd>VenvSelect<cr>", { desc = "Select Python venv" })
vim.keymap.set("n", "<leader>Js", "<cmd>JupyterStart<cr>", { desc = "Start Jupyter" })
vim.keymap.set("n", "<leader>Jq", "<cmd>JupyterStop<cr>", { desc = "Stop Jupyter" })
