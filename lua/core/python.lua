-- Python configuration for Windows Terminal environment
local M = {}

-- Disable unused providers for faster startup
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Python provider configuration
local function find_python()
	-- Priority order for Python detection
	local candidates = {
		-- Current project venv
		vim.fn.getcwd() .. "/.venv/Scripts/python.exe",
		-- Global Python installations
		"C:/Users/"
			.. vim.env.USERNAME
			.. "/AppData/Local/Programs/Python/Python313/python.exe",
		"C:/Users/" .. vim.env.USERNAME .. "/AppData/Local/Programs/Python/Python312/python.exe",
		"C:/Python313/python.exe",
		"C:/Python312/python.exe",
		-- Windows Store Python
		vim.env.LOCALAPPDATA .. "/Microsoft/WindowsApps/python.exe",
		-- Conda
		vim.env.CONDA_PREFIX and (vim.env.CONDA_PREFIX .. "/python.exe"),
	}

	for _, path in ipairs(candidates) do
		if path and vim.fn.filereadable(path) == 1 then
			return path
		end
	end

	-- Fallback to system python
	return "python"
end

-- Set Python provider
vim.g.python3_host_prog = find_python()

-- Virtual environment detection and switching
function M.detect_venv()
	local cwd = vim.fn.getcwd()
	local venv_paths = {
		cwd .. "/.venv/Scripts/python.exe",
		cwd .. "/venv/Scripts/python.exe",
		cwd .. "/.virtualenv/Scripts/python.exe",
	}

	for _, path in ipairs(venv_paths) do
		if vim.fn.filereadable(path) == 1 then
			vim.g.python3_host_prog = path
			vim.notify("✅ Using venv: " .. path, vim.log.levels.INFO)
			return path
		end
	end

	return nil
end

-- Create virtual environment for current project
function M.create_venv()
	local cwd = vim.fn.getcwd()
	local venv_path = cwd .. "/.venv"
	local python_exe = venv_path .. "/Scripts/python.exe"
	local project_name = vim.fn.fnamemodify(cwd, ":t")

	-- Create venv
	local create_result = vim.fn.system({ "py", "-m", "venv", venv_path })
	if vim.v.shell_error ~= 0 then
		vim.notify("❌ Failed to create venv: " .. create_result, vim.log.levels.ERROR)
		return
	end

	-- Upgrade pip and install essentials
	local packages = { "pip", "ipykernel", "jupyter", "matplotlib", "numpy", "pandas" }
	local install_cmd = { python_exe, "-m", "pip", "install", "--upgrade" }
	vim.list_extend(install_cmd, packages)

	vim.fn.system(install_cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("⚠️  Warning: Some packages may not have installed correctly", vim.log.levels.WARN)
	end

	-- Register Jupyter kernel
	vim.fn.system({
		python_exe,
		"-m",
		"ipykernel",
		"install",
		"--user",
		"--name",
		project_name,
		"--display-name",
		"Python (" .. project_name .. ")",
	})

	-- Update Python provider
	vim.g.python3_host_prog = python_exe

	vim.notify("✅ Virtual environment created: " .. project_name, vim.log.levels.INFO)
end

-- Auto-detect venv on startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(function()
			M.detect_venv()
		end)
	end,
})

-- Commands
vim.api.nvim_create_user_command("PyCreateVenv", M.create_venv, {})
vim.api.nvim_create_user_command("PyDetectVenv", M.detect_venv, {})

return M

