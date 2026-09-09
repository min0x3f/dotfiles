local function wide_window()
	return vim.fn.winwidth(0) > 100
end

local mode = {
	"mode",
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " },
	cond = wide_window,
}

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	cond = wide_window,
}

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		component_separators = "",
		section_separators = "",
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { "branch" },
		lualine_c = { diff, { "filename", file_status = true, path = 0 } },
		lualine_x = { diagnostics, { "filetype", cond = wide_window } },
		lualine_y = { "location" },
		lualine_z = { "progress" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { { "location", padding = 0 } },
		lualine_y = {},
		lualine_z = {},
	},
})
