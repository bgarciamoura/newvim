return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			javascript = { "biome" },
			typescript = { "biome" },
			javascriptreact = { "biome" },
			typescriptreact = { "biome" },
		}
		lint.linters.biome = {
			name = "biome",
			cmd = "biome",
			args = {
				"lint",
				"--formatter",
				"json",
				"--stdin-file-path",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			},
			stdin = true,
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c %m", {
				source = "biome",
				severity = vim.diagnostic.severity.WARN,
			}),
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
