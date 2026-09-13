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
		vim.api.nvim_set_hl(0, "Folded", { fg = "#586e75" })
		vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#93a1a1", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "CursorLineFold", { fg = "#586e75" })
	end
end

local function style_terminal_palette()
	if vim.g.colors_name and vim.g.colors_name:find("solarized8") then
		local palette = {
			"#eee8d5",
			"#dc322f",
			"#859900",
			"#b58900",
			"#268bd2",
			"#d33682",
			"#2aa198",
			"#073642",
			"#fdf6e3",
			"#cb4b16",
			"#93a1a1",
			"#839496",
			"#657b83",
			"#6c71c4",
			"#586e75",
			"#002b36",
		}

		for index, color in ipairs(palette) do
			vim.g["terminal_color_" .. index - 1] = color
		end
	end
end

local function style_snacks()
	if vim.g.colors_name and vim.g.colors_name:find("solarized8") then
		vim.api.nvim_set_hl(0, "SnacksNormal", { fg = "#657b83", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksNormalNC", { fg = "#657b83", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksWinBar", { fg = "#586e75", bg = "#eee8d5", bold = true })
		vim.api.nvim_set_hl(0, "SnacksWinBarNC", { fg = "#586e75", bg = "#eee8d5" })
		vim.api.nvim_set_hl(0, "SnacksWinSeparator", { fg = "#93a1a1", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksTitle", { fg = "#586e75", bg = "#eee8d5", bold = true })
		vim.api.nvim_set_hl(0, "SnacksFooter", { fg = "#586e75", bg = "#eee8d5" })
		vim.api.nvim_set_hl(0, "SnacksPicker", { fg = "#657b83", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksPickerInput", { fg = "#657b83", bg = "#eee8d5" })
		vim.api.nvim_set_hl(0, "SnacksPickerList", { fg = "#657b83", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksPickerPreview", { fg = "#657b83", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#93a1a1", bg = "#fdf6e3" })
		vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = "#2aa198", bg = "#eee8d5" })
		vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#b58900", bold = true })
		vim.api.nvim_set_hl(0, "SnacksPickerPrompt", { fg = "#268bd2", bold = true })
		vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#657b83" })
		vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { fg = "#2aa198", bold = true })
		vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#93a1a1" })
		vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#93a1a1", italic = true })
		vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { fg = "#93a1a1", italic = true })
		vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#eee8d5" })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#b58900", bold = true })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#cb4b16" })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatusStaged", { fg = "#2aa198" })
		vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#859900" })
	end
end

local group = vim.api.nvim_create_augroup("scratch-colorscheme", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	callback = function()
		dim_listchars()
		style_folds()
		style_terminal_palette()
		style_snacks()
	end,
})

dim_listchars()
style_folds()
style_terminal_palette()
style_snacks()
