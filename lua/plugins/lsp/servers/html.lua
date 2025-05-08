return {
	settings = {
		html = {
			format = {
				indentInnerHtml = true,
				wrapLineLength = 120,
				wrapAttributes = "auto",
			},
			suggest = {
				html5 = true,
			},
		},
	},
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
}
