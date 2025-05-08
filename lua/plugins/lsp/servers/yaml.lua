return {
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},

			format = {
				enable = true,
				singleQuote = false,
				bracketSpacing = true,
				proseWrap = "preserve",
				printWidth = 100,
			},
			validate = true,
			completion = true,
			hover = true,
		},
	},
}
