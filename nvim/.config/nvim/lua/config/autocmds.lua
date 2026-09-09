local group = vim.api.nvim_create_augroup("scratch-highlight-yank", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})
