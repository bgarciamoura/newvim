-- Jupyter plugins configuration for Windows Terminal (Iron-focused)
return {
	-- Iron.nvim - Python REPL (Primary solution)
	{
		"Vigemus/iron.nvim", 
		ft = { "python" },
		cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
		config = function()
			local iron = require("iron.core")
			
			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						python = {
							command = function()
								return { vim.g.python3_host_prog or "python" }
							end,
							format = require("iron.fts.common").bracketed_paste,
						},
					},
					repl_open_cmd = require("iron.view").split.vertical.botright(60),
				},
				keymaps = {
					send_motion = "<localleader>sm",
					visual_send = "<localleader>sv", 
					send_line = "<localleader>sl",
					send_until_cursor = "<localleader>su",
					cr = "<localleader>s<cr>",
					interrupt = "<localleader>si",
					exit = "<localleader>sq",
					clear = "<localleader>cl",
				},
				highlight = { italic = true },
			})
			
			-- Auto-start message for Python files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					vim.defer_fn(function()
						vim.notify("💻 Iron REPL ready. Use <localleader>rs to start", vim.log.levels.INFO)
					end, 1000)
				end,
			})
		end,
	},

	-- Jupyter text format support
	{
		"GCBallesteros/jupytext.nvim",
		config = function()
			require("jupytext").setup({
				style = "percent", -- Use # %% for cell markers
				output_extension = "auto", -- Auto-detect format
				force_ft = nil,
				custom_language_formatting = {},
			})
			
			-- Auto-convert .ipynb to .py on open
			vim.api.nvim_create_autocmd("BufReadPost", {
				pattern = "*.ipynb",
				callback = function()
					-- Convert to python format for editing
					vim.cmd("Jupytext --to py:percent")
					vim.bo.filetype = "python"
					vim.notify("📓 Notebook converted to Python format for editing", vim.log.levels.INFO)
				end,
			})
			
			-- Auto-sync back to .ipynb on save
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.py",
				callback = function()
					local filename = vim.fn.expand("%:t:r")
					local ipynb_file = filename .. ".ipynb"
					if vim.fn.filereadable(ipynb_file) == 1 then
						vim.cmd("Jupytext --sync")
						vim.notify("🔄 Synced with " .. ipynb_file, vim.log.levels.INFO)
					end
				end,
			})
		end,
		ft = { "python", "julia", "r", "markdown" },
		cmd = { "Jupytext" },
	},

	-- Python environment selector
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap-python",
		},
		event = "VeryLazy",
		cmd = { "VenvSelect", "VenvSelectCached" },
		keys = {
			{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python Venv" },
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
		},
		config = function()
			require("venv-selector").setup({
				settings = {
					search = {
						my_venvs = {
							command = "fd python.exe .venv Scripts",
						},
						anaconda_base = {
							command = "fd python.exe /c/Users/"
								.. vim.env.USERNAME
								.. "/anaconda3/envs /c/ProgramData/anaconda3/envs",
							type = "anaconda",
						},
						anaconda_envs = {
							command = "fd python.exe /c/Users/"
								.. vim.env.USERNAME
								.. "/miniconda3/envs /c/ProgramData/miniconda3/envs",
							type = "anaconda",
						},
						miniconda = {
							command = "fd python.exe /c/Users/" .. vim.env.USERNAME .. "/miniconda3 /c/ProgramData/miniconda3",
							type = "miniconda",
						},
					},
				},
				options = {
					notify_user_on_venv_activation = true,
				},
			})
		end,
	},

	-- Quarto for scientific documents (Iron-focused)
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto", "markdown", "python" },
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					languages = { "python", "bash", "html", "lua" },
					chunks = "all",
					diagnostics = {
						enabled = true,
						triggers = { "BufWritePost" },
					},
					completion = {
						enabled = true,
					},
				},
				keymap = {
					hover = "K",
					definition = "gd",
					rename = "<leader>rn",
					references = "gr",
					format = "<leader>gf",
				},
				codeRunner = {
					enabled = true,
					default_method = "iron",  -- Changed from molten to iron
				},
			})
		end,
	},
}