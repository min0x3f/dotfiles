require("blink.cmp").setup({
	keymap = { preset = "enter" },
	completion = {
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
		accept = {
			auto_brackets = { enabled = false },
		},
	},
})
