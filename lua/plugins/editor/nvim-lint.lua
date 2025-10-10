return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- util: acha arquivo subindo diretórios
		local function nearest(patterns, buf)
			local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf or 0))
			-- Ensure dir is a string
			if type(dir) == "table" then
				dir = dir[1] or vim.loop.cwd()
			end
			local found = vim.fs.find(patterns, { path = dir, upward = true, type = "file" })
			return #found > 0
		end

		-- Biome (usa o linter embutido biomejs)
		if lint.linters.biomejs then
			lint.linters.biomejs.condition = function(ctx)
				return nearest({ "biome.json", "biome.jsonc" }, ctx.buf)
			end
			-- dica: se quiser forçar saída JSON sempre, dá pra sobrepor args:
			-- local b = lint.linters.biomejs
			-- b.args = { "lint", "--reporter", "json", "--stdin-file-path", function() return vim.api.nvim_buf_get_name(0) end }
			-- b.stdin = true
			-- b.stream = "both" -- alguns builds escrevem diag em stderr; 'both' garante captura
			-- b.ignore_exitcode = true
		end

		-- ESLint (daemon)
		if lint.linters.eslint_d then
			lint.linters.eslint_d.condition = function(ctx)
				return nearest({
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.mjs",
					".eslintrc.json",
					".eslintrc.yaml",
					".eslintrc.yml",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts",
				}, ctx.buf)
			end
			-- garante JSON via stdin (nvim-lint já sabe parsear)
			lint.linters.eslint_d.args = {
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
				"--format",
				"json",
			}
		end

		-- Prioridade: Biome > ESLint
		lint.linters_by_ft = {
			javascript = { "biomejs", "eslint_d" },
			javascriptreact = { "biomejs", "eslint_d" },
			typescript = { "biomejs", "eslint_d" },
			typescriptreact = { "biomejs", "eslint_d" },
		}

		-- Auto-lint em momentos úteis
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
