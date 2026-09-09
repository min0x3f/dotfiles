require("snacks").setup({
	explorer = {
		enabled = true,
		replace_netrw = false,
	},
	input = { enabled = false },
	picker = {
		enabled = true,
		layout = { preset = "ivy" },
	},
	lazygit = {},
	terminal = {
		win = {
			position = "right",
			width = 0.5,
		},
	},
})
