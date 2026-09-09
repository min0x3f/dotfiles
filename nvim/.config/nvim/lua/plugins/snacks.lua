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
	lazygit = {
		win = {
			position = "float",
			width = 0.9,
			height = 0.9,
			border = "rounded",
		},
	},
	terminal = {
		win = {
			position = "right",
			width = 0.5,
		},
	},
})
