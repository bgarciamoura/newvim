-- helper pra detectar arquivos no projeto
local function has_any(root, patterns)
	local found = vim.fs.find(patterns, { path = root, upward = true, type = "file", stop = vim.loop.os_homedir() })
	return #found > 0
end

local function project_root()
	local root = vim.fs.root(0, { "pnpm-workspace.yaml", "package.json", "tsconfig.json", ".git" })
	-- vim.fs.root() pode retornar string, array ou nil dependendo da versão do Neovim
	if type(root) == "table" then
		root = root[1]
	end
	return root or vim.loop.cwd()
end

-- condições por projeto
local function use_biome()
	local root = project_root()
	return has_any(root, { "biome.json", "biome.jsonc" }) -- config padrão
		-- alguns projetos declaram em package.json
		or (function()
			local pkg = vim.fs.find("package.json", { path = root, upward = true, type = "file" })[1]
			if not pkg then
				return false
			end
			local ok, json = pcall(vim.fn.readfile, pkg)
			if not ok then
				return false
			end
			local str = table.concat(json, "\n")
			return str:match('"biome"%s*:') ~= nil
		end)()
end

local function use_eslint()
	local root = project_root()
	return has_any(root, {
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
	})
end

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			javascript = function()
				if use_biome() then
					return { "biome" }
				elseif use_eslint() then
					return { "eslint_d" } -- usa regras do projeto; requer config ESLint
				else
					return { "prettierd", "prettier" } -- daemons são mais rápidos
				end
			end,
			javascriptreact = function()
				if use_biome() then
					return { "biome" }
				elseif use_eslint() then
					return { "eslint_d" }
				else
					return { "prettierd", "prettier" }
				end
			end,
			typescript = function()
				if use_biome() then
					return { "biome" }
				elseif use_eslint() then
					return { "eslint_d" }
				else
					return { "prettierd", "prettier" }
				end
			end,
			typescriptreact = function()
				if use_biome() then
					return { "biome" }
				elseif use_eslint() then
					return { "eslint_d" }
				else
					return { "prettierd", "prettier" }
				end
			end,
			biome = {
				command = "biome",
				args = { "format", "--stdin-file-path", "$FILENAME" },
				stdin = true,
				require_cwd = true,
			},
			prettierd = {
				command = "prettierd",
				args = { "$FILENAME" },
				stdin = true,
				require_cwd = true,
			},
			json = { "biome", "prettierd", "prettier" },
			jsonc = { "biome", "prettierd", "prettier" },
			yaml = { "yamlfmt" },
			html = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			scss = { "prettierd", "prettier" },
			markdown = { "prettierd", "prettier" },
			lua = { "stylua" },
			sh = { "shfmt" },
		},
		formatters = {
			biome = {
				-- Força usar o do Mason com comando padrão
				-- (Conform já resolve o bin pelo PATH; se quiser hardcodear, dá pra sobrepor "command")
				args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
				stdin = true,
			},
			eslint_d = {
				-- garante que use fix
				args = { "--stdin", "--stdin-filename", "$FILENAME", "--fix-to-stdout" },
				stdin = true,
				cwd = project_root,
				-- evita rodar sem config no projeto
				condition = function(ctx)
					return use_eslint()
				end,
			},
			prettierd = {
				stdin = true,
			},
		},
		format_on_save = {
			timeout_ms = 3000,
			lsp_format = "fallback",
		},
	},
}
