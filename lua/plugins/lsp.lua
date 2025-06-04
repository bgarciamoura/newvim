return {
	"neovim/nvim-lspconfig",
	config = function()
		require("mason").setup({
			registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
		})
		require("mason-lspconfig").setup()
		require("roslyn").setup()
		require("blink.cmp").setup({
			keymap = {
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
						cmp.hide()
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
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
			},
			snippets = {
				preset = "luasnip",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "conventional_commits", "avante", "env", "nerdfont" },
				providers = {
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						fallbacks = { "buffer" },
						-- Mantém as configurações padrão para funcionalidades como auto-import
						opts = {},
					},
					conventional_commits = {
						name = "Conventional Commits",
						module = "blink-cmp-conventional-commits",
						enabled = function()
							return vim.bo.filetype == "gitcommit"
						end,
						opts = {},
					},
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
						opts = {},
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
							search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
						},
					},
					nerdfont = {
						module = "blink-nerdfont",
						name = "Nerd Fonts",
						score_offset = 15,
						opts = { insert = true },
					},
					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						opts = {
							search_paths = {
								vim.fn.stdpath("config") .. "/snippets",
							},
						},
					},
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},
			opts_extend = { "sources.default" },

			-- Configuração mais sutil para evitar conflitos SEM quebrar funcionalidades
			config = function(_, opts)
				require("blink.cmp").setup(opts)

				-- Carrega os snippets via LuaSnip
				local luasnip_status, luasnip = pcall(require, "luasnip")
				if luasnip_status then
					-- Carrega snippets amigáveis
					require("luasnip.loaders.from_vscode").lazy_load()

					-- Carrega snippets personalizados
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})
				end
			end,
		})

		vim.diagnostic.config({
			signs = {
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				},
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "󰋽",
					[vim.diagnostic.severity.WARN] = "",
				},
			},
			update_in_insert = true,
			virtual_text = false,
			virtual_lines = { current_line = true },
		})
	end,
	dependencies = {
		"seblyng/roslyn.nvim",
		"mason-org/mason-lspconfig.nvim",
		"mason-org/mason.nvim",
		{
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
		},
	},
}
