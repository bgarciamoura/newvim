return {
	"kosayoda/nvim-lightbulb",
	event = "LspAttach",
	opts = {
		sign = {
			enabled = true,
			text = "💡",
			hl = "DiagnosticSignWarn",
		},
		virtual_text = {
			enabled = false,
		},
		float = {
			enabled = false,
		},
		autocmd = {
			enabled = true,
			updatetime = 200,
			events = { "CursorHold", "CursorHoldI" },
		},
	},
}
