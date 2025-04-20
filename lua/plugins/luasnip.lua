return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()

		local ls = require("luasnip")

		-- Configuração de teclas para navegação nos snippets
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(1) then
				ls.jump(1)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		-- Habilitar snippets para Filetype específicos
		ls.filetype_extend("javascript", { "html" })
		ls.filetype_extend("typescript", { "javascript" })
		ls.filetype_extend("javascriptreact", { "javascript", "html" })
		ls.filetype_extend("typescriptreact", { "typescript", "javascriptreact" })
		ls.filetype_extend("htmlangular", { "html", "typescript" })
		ls.filetype_extend("vue", { "html", "javascript" })
		ls.filetype_extend("svelte", { "html", "javascript" })
		ls.filetype_extend("astro", { "html", "javascript" })

		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node

		-- Adicionar snippets específicos para NestJS
		ls.add_snippets("typescript", {
			-- Módulo NestJS
			s("nmodule", {
				t("import { Module } from '@nestjs/common';"),
				t({ "", "" }),
				t("@Module({"),
				t({ "", "  imports: [" }),
				i(1, ""),
				t({ "", "  ]," }),
				t({ "", "  controllers: [" }),
				i(2, ""),
				t({ "", "  ]," }),
				t({ "", "  providers: [" }),
				i(3, ""),
				t({ "", "  ]," }),
				t({ "", "  exports: [" }),
				i(4, ""),
				t({ "", "  ]," }),
				t({ "", "}" }),
				t({ "", "export class " }),
				i(5, "Name"),
				t("Module {}"),
			}),

			-- Controller NestJS
			s("ncontroller", {
				t("import { Controller } from '@nestjs/common';"),
				t({ "", "" }),
				t("@Controller('"),
				i(1, "path"),
				t("')"),
				t({ "", "export class " }),
				i(2, "Name"),
				t("Controller {"),
				t({ "", "  constructor(" }),
				i(3, ""),
				t(") {}"),
				t({ "", "" }),
				t({ "", "}" }),
			}),

			-- GET Endpoint
			s("nget", {
				t("@Get('"),
				i(1, "path"),
				t("')"),
				t({ "", "async " }),
				i(2, "methodName"),
				t("("),
				i(3, ""),
				t(") {"),
				t({ "", "  " }),
				i(4, "return"),
				t({ "", "}" }),
			}),

			-- Service NestJS
			s("nservice", {
				t("import { Injectable } from '@nestjs/common';"),
				t({ "", "" }),
				t("@Injectable()"),
				t({ "", "export class " }),
				i(1, "Name"),
				t("Service {"),
				t({ "", "  constructor(" }),
				i(2, ""),
				t(") {}"),
				t({ "", "" }),
				t({ "", "}" }),
			}),
		})
	end,
}
