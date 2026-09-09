vim.opt.background = "light"

require("solarized-osaka").setup({
	transparent = false,
})

vim.cmd.colorscheme("solarized8_flat")

-- Dim list characters for solarized8_flat (using base02 #eee8d5 for subtle indicators)
local function dim_listchars()
	if vim.g.colors_name and vim.g.colors_name:find("solarized8") then
		local subtle = "#eee8d5"
		local highlight = {
			fg = subtle,
			bold = false,
			cterm = { bold = false },
		}
		vim.api.nvim_set_hl(0, "Whitespace", highlight)
		vim.api.nvim_set_hl(0, "NonText", highlight)
	end
end

local function style_folds()
	if vim.g.colors_name and vim.g.colors_name:find("solarized8") then
		vim.api.nvim_set_hl(0, "Folded", { fg = "#586e75", bg = "#eee8d5", bold = true })
		vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#93a1a1", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "CursorLineFold", { fg = "#586e75", bg = "#eee8d5", bold = true })
	end
end

local group = vim.api.nvim_create_augroup("scratch-colorscheme", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	callback = function()
		dim_listchars()
		style_folds()
	end,
})

dim_listchars()
style_folds()
