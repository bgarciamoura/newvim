local M = {}

function M.setup()
	-- Cores para o menu de completação
	vim.api.nvim_set_hl(0, "CmpNormal", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "CmpBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "CmpSel", { link = "PmenuSel" })

	-- Cores para a documentação
	vim.api.nvim_set_hl(0, "CmpDocNormal", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "CmpDocBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "CmpDocSel", { link = "PmenuSel" })

	-- Cores para os diferentes tipos de itens
	vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#808080", strikethrough = true })
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#569CD6", bold = true })
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#569CD6", bold = true })
	vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9CDCFE" })
	vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#9CDCFE" })
	vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9CDCFE" })
	vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#C586C0" })
	vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#C586C0" })
	vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#D4D4D4" })
	vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#D4D4D4" })
	vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#D4D4D4" })
end

return M
