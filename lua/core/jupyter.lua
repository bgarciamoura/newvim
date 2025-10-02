-- Jupyter configuration optimized for Iron REPL and Windows Terminal
local M = {}

-- Check if we have a valid Python environment
local function has_python_env()
	local python_path = vim.g.python3_host_prog
	return python_path and vim.fn.filereadable(python_path) == 1
end

-- Setup autocmds for Python files
function M.setup_autocmds()
	local group = vim.api.nvim_create_augroup("JupyterConfig", { clear = true })

	-- Auto-setup for Python files
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = { "python" },
		callback = function()
			if has_python_env() then
				-- Set up cell markers for Python files
				vim.b.iron_cell_marker = "# %%"
			end
		end,
	})
end

-- Initialize Jupyter configuration
function M.setup()
	M.setup_autocmds()

	-- Global commands for Iron REPL
	vim.api.nvim_create_user_command("JupyterStart", function()
		if not has_python_env() then
			vim.notify("❌ No Python environment found. Run :PyCreateVenv first", vim.log.levels.ERROR)
			return
		end

		-- Start Iron REPL
		if vim.fn.exists(":IronRepl") == 2 then
			pcall(vim.cmd, "IronRepl")
			vim.notify("🚀 Iron REPL started", vim.log.levels.INFO)
		else
			vim.notify("❌ Iron REPL plugin not available", vim.log.levels.ERROR)
		end
	end, { desc = "Start Iron REPL" })

	vim.api.nvim_create_user_command("JupyterStop", function()
		if vim.fn.exists(":IronHide") == 2 then
			pcall(vim.cmd, "IronHide")
		end
		vim.notify("🛑 REPL stopped", vim.log.levels.INFO)
	end, { desc = "Stop Iron REPL" })
	
	-- Notebook conversion commands
	vim.api.nvim_create_user_command("NotebookOpen", function()
		local file = vim.fn.input("Notebook file: ", "", "file")
		if file ~= "" then
			vim.cmd("edit " .. file)
		end
	end, { desc = "Open notebook file" })
	
	vim.api.nvim_create_user_command("NotebookSync", function()
		local filename = vim.fn.expand("%:p")
		pcall(vim.cmd, "!jupytext --sync " .. vim.fn.shellescape(filename))
		vim.notify("📓 Notebook synced", vim.log.levels.INFO)
	end, { desc = "Sync notebook with paired file" })
	
	vim.api.nvim_create_user_command("NotebookToPy", function()
		local filename = vim.fn.expand("%:p")
		pcall(vim.cmd, "!jupytext --to py:percent " .. vim.fn.shellescape(filename))
		vim.notify("🐍 Converted to Python format", vim.log.levels.INFO)
	end, { desc = "Convert notebook to Python" })
	
	vim.api.nvim_create_user_command("NotebookToIpynb", function()
		local filename = vim.fn.expand("%:p")
		pcall(vim.cmd, "!jupytext --to ipynb " .. vim.fn.shellescape(filename))
		vim.notify("📓 Converted to notebook format", vim.log.levels.INFO)
	end, { desc = "Convert Python to notebook" })

	-- Add Jupytext metadata to current Python file
	vim.api.nvim_create_user_command("NotebookAddMeta", function()
		local filetype = vim.bo.filetype
		if filetype ~= "python" then
			vim.notify("❌ This command only works with Python files", vim.log.levels.ERROR)
			return
		end

		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local has_metadata = false
		
		-- Check if file already has Jupytext metadata
		for i, line in ipairs(lines) do
			if line:match("^# jupyter:") then
				has_metadata = true
				break
			end
		end

		if has_metadata then
			vim.notify("📓 File already has Jupytext metadata", vim.log.levels.INFO)
			return
		end

		-- Add metadata at the beginning
		local metadata = {
			"# ---",
			"# jupyter:",
			"#   jupytext:",
			"#     text_representation:",
			"#       extension: .py",
			"#       format_name: percent",
			"#       format_version: '1.3'",
			"#       jupytext_version: 1.17.3",
			"#   kernelspec:",
			"#     display_name: Python 3",
			"#     language: python",
			"#     name: python3",
			"# ---",
			""
		}

		vim.api.nvim_buf_set_lines(0, 0, 0, false, metadata)
		vim.notify("✅ Jupytext metadata added", vim.log.levels.INFO)
	end, { desc = "Add Jupytext metadata to Python file" })
end

-- Call setup
M.setup()

return M