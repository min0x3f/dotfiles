local function fold_virt_text_handler(virt_text, lnum, end_lnum, width, truncate)
	local suffix = string.format(" ⋯  󰁂 %d lines", end_lnum - lnum)
	local suffix_width = vim.fn.strdisplaywidth(suffix)
	local target_width = width - suffix_width
	local new_virt_text = {}
	local current_width = 0

	for _, chunk in ipairs(virt_text) do
		local text = chunk[1]
		local text_width = vim.fn.strdisplaywidth(text)

		if target_width > current_width + text_width then
			table.insert(new_virt_text, chunk)
			current_width = current_width + text_width
		else
			text = truncate(text, target_width - current_width)
			text_width = vim.fn.strdisplaywidth(text)
			if current_width + text_width < target_width then
				suffix = suffix .. string.rep(" ", target_width - current_width - text_width)
			end
			table.insert(new_virt_text, { text, chunk[2] })
			break
		end
	end

	table.insert(new_virt_text, { suffix, "UfoFoldedEllipsis" })
	return new_virt_text
end

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup({
	open_fold_hl_timeout = 0,
	provider_selector = function(_, filetype, buftype)
		if buftype == "terminal" then
			return ""
		end

		if vim.tbl_contains({ "cpp", "cxx", "cc" }, filetype) then
			return { "treesitter", "indent" }
		end

		if vim.tbl_contains({ "c", "lua", "python" }, filetype) then
			return { "lsp", "treesitter" }
		end

		return { "treesitter", "indent" }
	end,
	fold_virt_text_handler = fold_virt_text_handler,
})

-- Without an explicit background, ufo links this group to Visual by default.
vim.api.nvim_set_hl(0, "UfoFoldedBg", { link = "Normal" })

vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zK", function()
	if not require("ufo").peekFoldedLinesUnderCursor() then
		vim.lsp.buf.hover()
	end
end, { desc = "Preview folded lines" })

local group = vim.api.nvim_create_augroup("scratch-ufo", { clear = true })
local cpp_declaration_query = vim.treesitter.query.parse(
	"cpp",
	[[
[
  (namespace_definition)
  (struct_specifier)
  (class_specifier)
] @declaration
]]
)

local function close_cpp_declarations(bufnr, winid)
	if not (vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_win_is_valid(winid)) then
		return
	end

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "cpp")
	if not ok then
		return
	end

	local lines = {}
	parser:for_each_tree(function(tree, language_tree)
		if language_tree:lang() == "cpp" then
			for _, node in cpp_declaration_query:iter_captures(tree:root(), bufnr, 0, -1) do
				local parent = node:parent()
				while
					parent
					and not vim.tbl_contains(
						{ "namespace_definition", "struct_specifier", "class_specifier", "function_definition" },
						parent:type()
					)
				do
					parent = parent:parent()
				end

				if not parent or parent:type() == "namespace_definition" then
					table.insert(lines, node:start() + 1)
				end
			end
		end
	end)
	table.sort(lines, function(a, b)
		return a > b
	end)

	vim.api.nvim_win_call(winid, function()
		local view = vim.fn.winsaveview()
		for _, line in ipairs(lines) do
			if vim.fn.foldlevel(line) > vim.fn.foldlevel(line - 1) then
				vim.api.nvim_win_set_cursor(winid, { line, 0 })
				pcall(vim.cmd, "normal! zc")
			end
		end
		vim.fn.winrestview(view)
	end)
end

vim.keymap.set("n", "zM", function()
	if vim.tbl_contains({ "cpp", "cxx", "cc" }, vim.bo.filetype) then
		require("ufo").openAllFolds()
		close_cpp_declarations(vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win())
		return
	end

	require("ufo").closeAllFolds()
end, { desc = "Close C++ declaration folds" })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "cpp", "cxx", "cc" },
	callback = function(args)
		local bufnr = args.buf
		local winid = vim.api.nvim_get_current_win()
		vim.defer_fn(function()
			close_cpp_declarations(bufnr, winid)
		end, 200)
	end,
})
