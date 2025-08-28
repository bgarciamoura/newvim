return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.setup({
				-- se notar problemas de indent após <CR>, dá pra setar map_cr=false
				-- e deixar o indent só pro Treesitter/ftplugin
				map_cr = true,
				check_ts = true, -- usa Treesitter pras decisões de pareamento
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
					java = false,
				},
				enable_check_bracket_line = true, -- evita duplicar ) ] } na mesma linha
				ignored_next_char = "[%w%.]", -- ignora parear antes de alfanum/ .
			})

			-- FastWrap: <Alt-e> abre o modo de embrulhar rapidamente
			npairs.setup({
				fast_wrap = {
					map = "<M-e>",
					chars = { "{", "[", "(", '"', "'" },
					pattern = [=[[%'%"%>%]%)%}%,]]=],
					end_key = "$",
					before_key = "h",
					after_key = "l",
					cursor_pos_before = true,
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					manual_position = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
			})

			-- ===== Regras de exemplo (LaTeX / tex) =====
			-- $$ ... $$
			npairs.add_rule(Rule("$$", "$$", "tex"))

			-- $ ... $ com condições (só em tex/latex)
			npairs.add_rules({
				Rule("$", "$", { "tex", "latex" })
					:with_pair(cond.not_after_regex("%%")) -- não pariar se próximo char é %
					:with_pair(cond.not_before_regex("xxx", 3)) -- exemplo didático
					:with_move(cond.none())
					:with_del(cond.not_after_regex("xx"))
					:with_cr(cond.none()), -- não inserir newline especial no <CR>
			})

			-- Excluir filetypes p/ essa regra (exemplo)
			npairs.add_rule(Rule("$$", "$$"):with_pair(cond.not_filetypes({ "lua" })))

			-- ===== Regras com regex (exemplos divertidos) =====
			npairs.add_rules({
				Rule("u%d%d%d%d$", "number", "lua"):use_regex(true), -- digita u1234 => …number
				Rule("x%d%d%d%d$", "number", "lua"):use_regex(true):replace_endpair(function(opts)
					return opts.prev_char:sub(#opts.prev_char - 3, #opts.prev_char)
				end),
			})

			-- ===== Treesitter conditions (exemplo) =====
			local ts_conds = require("nvim-autopairs.ts-conds")
			npairs.add_rules({
				Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
				Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
}
