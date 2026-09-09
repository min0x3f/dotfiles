local treesitter = require("nvim-treesitter")

-- nvim-treesitter ships its query files under runtime/, which native vim.pack
-- does not add to runtimepath automatically.
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime")
vim.opt.fillchars:remove({ foldclose = "▸", foldopen = "▾", foldsep = " " })
vim.opt.fillchars:append({ fold = " " })

function _G.CppFoldText()
	local header = vim.fn.getline(vim.v.foldstart):gsub("^%s+", ""):gsub("%s*{%s*$", "")
	local lines = vim.v.foldend - vim.v.foldstart + 1
	return string.format("›  %s { ... }  ·  %d lines", header, lines)
end

local parsers = {
	"bash",
	"c",
	"cpp",
	"go",
	"json",
	"latex",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"toml",
	"typst",
	"vim",
	"vimdoc",
	"yaml",
}

treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.treesitter.query.set(
	"cpp",
	"folds",
	[[
[
  (namespace_definition)
  (struct_specifier)
  (class_specifier)
] @fold
]]
)

treesitter.install(parsers)

local group = vim.api.nvim_create_augroup("scratch-treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"bash",
		"c",
		"cpp",
		"go",
		"help",
		"json",
		"jsonc",
		"lua",
		"markdown",
		"python",
		"query",
		"sh",
		"tex",
		"toml",
		"typst",
		"vim",
		"yaml",
	},
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "cpp",
	callback = function(args)
		local bufnr = args.buf
		local winid = vim.api.nvim_get_current_win()

		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldtext = "v:lua.CppFoldText()"
		vim.wo.foldenable = true
		vim.wo.foldcolumn = "0"
		vim.wo.foldnestmax = 2
		vim.wo.foldlevel = 0

		vim.schedule(function()
			local current_buffer = vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr
			if vim.api.nvim_buf_is_valid(bufnr) and current_buffer then
				vim.api.nvim_win_call(winid, function()
					vim.treesitter.foldexpr(1)
					vim.cmd("normal! zM")
				end)
			end
		end)
	end,
})
