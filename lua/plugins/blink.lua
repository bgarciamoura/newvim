return {
	"saghen/blink.cmp",
	dependencies = {
		{ "disrupted/blink-cmp-conventional-commits" },
		{ "rafamadriz/friendly-snippets" },
		{ "Kaiser-Yang/blink-cmp-avante" },
		{ "bydlw98/blink-cmp-env" },
		{ "jdrupal-dev/css-vars.nvim" },
		{ "MahanRahmati/blink-nerdfont.nvim" },
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		completion = {
			documentation = {
				auto_show = true,
			},
		},
		snippets = {
			preset = "luasnip",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev", "conventional_commits", "avante", "env", "nerdfont" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100, -- make lazydev completions top priority (see `:h blink.cmp`)
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {}, -- none so far
				},
				avante = {
					module = "blink-cmp-avante",
					name = "Avante",
					opts = {
						-- options for blink-cmp-avante
					},
				},
				env = {
					name = "Env",
					module = "blink-cmp-env",
					opts = {
						show_braces = false,
						show_documentation_window = true,
					},
				},
				css_vars = {
					name = "css-vars",
					module = "css-vars.blink",
					opts = {
						-- WARNING: The search is not optimized to look for variables in JS files.
						-- If you change the search_extensions you might get false positives and weird completion results.
						search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
					},
				},
				nerdfont = {
					module = "blink-nerdfont",
					name = "Nerd Fonts",
					score_offset = 15, -- Tune by preference
					opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
				},
			},
		},
		signature = { enabled = true },
	},

	opts_extend = { "sources.default" },
}
