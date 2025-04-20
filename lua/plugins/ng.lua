return {
	"joeveiga/ng.nvim",
	config = function()
		local ng = require("ng")

		vim.keymap.set(
			"n",
			"<leader>at",
			ng.goto_template_for_component,
			{ desc = "Go to the Angular template of the component" }
		)
		vim.keymap.set(
			"n",
			"<leader>ac",
			ng.goto_component_with_template_file,
			{ desc = "Go to the Angular component of the template" }
		)
		vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, { desc = "Get the Angular template TCB" })
	end,
}
