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
		keymap = {
			-- set to 'none' to disable the 'default' preset
			preset = "enter",
			["<C-space>"] = {
				function(cmp)
					cmp.show()
				end,
			},
			["<C-d>"] = {
				function(cmp)
					cmp.show_documentation()
				end,
			},
			["<C-n>"] = {
				function(cmp)
					cmp.snippet_forward()
				end,
			},
			["<C-p>"] = {
				function(cmp)
					cmp.snippet_backward()
				end,
			},
			["<C-e>"] = {
				function(cmp)
					cmp.close()
				end,
			},

			["<C-u>"] = {
				function(cmp)
					cmp.scroll_docs(-4)
				end,
			},
			["<C-f>"] = {
				function(cmp)
					cmp.scroll_docs(4)
				end,
			},
		},
		completion = {
			documentation = {
				auto_show = true,
			},
			-- Configuração específica para evitar conflitos com LSP nativo
			list = {
				selection = {
					preselect = true,
					auto_insert = false, -- Desabilita auto-inserção para evitar conflitos
				},
			},
		},
		snippets = {
			preset = "luasnip",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev", "conventional_commits", "avante", "env", "nerdfont" },
			providers = {
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					fallbacks = { "buffer" },
					-- Configurações específicas para o LSP provider
					opts = {
						-- Desabilita detecção automática de trigger characters
						-- para evitar conflitos com o sistema nativo
						auto_trigger_chars = {},
					},
				},
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
		signature = {
			enabled = true,
			-- Configuração para evitar conflitos
			window = {
				border = "rounded",
			},
		},
	},

	opts_extend = { "sources.default" },

	-- Configuração adicional para garantir compatibilidade
	config = function(_, opts)
		-- Desabilita explicitamente o sistema de completação nativo do Neovim
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				-- Remove capacidade de completação para forçar uso do blink.cmp
				if client and client.server_capabilities then
					client.server_capabilities.completionProvider = false
				end
			end,
		})

		require("blink.cmp").setup(opts)
	end,
}
