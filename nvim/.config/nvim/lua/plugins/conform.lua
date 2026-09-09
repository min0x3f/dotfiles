require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_format" },
		lua = { "stylua" },
	},
	format_on_save = function(bufnr)
		local filetype = vim.bo[bufnr].filetype
		if filetype == "python" or filetype == "lua" then
			return { timeout_ms = 1000, lsp_format = "never" }
		end
	end,
})
