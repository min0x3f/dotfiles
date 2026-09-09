local group = vim.api.nvim_create_augroup("scratch-make", { clear = true })

local function set_compiled_makeprg(args, makefile)
	local source = vim.api.nvim_buf_get_name(args.buf)
	local directory = vim.fn.fnamemodify(source, ":h")

	if vim.fn.filereadable(directory .. "/Makefile") == 1 then
		vim.bo[args.buf].makeprg = "make -C " .. vim.fn.shellescape(directory)
		return
	end

	vim.bo[args.buf].makeprg = table.concat({
		"make -C ",
		vim.fn.shellescape(directory),
		" -f ",
		vim.fn.shellescape(vim.fn.stdpath("config") .. "/make/" .. makefile),
		" SOURCE=",
		vim.fn.shellescape(source),
	})
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "cpp", "cxx", "cc" },
	callback = function(args)
		set_compiled_makeprg(args, "cpp-practice.mk")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "c",
	callback = function(args)
		set_compiled_makeprg(args, "c-practice.mk")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "python",
	callback = function(args)
		vim.bo[args.buf].makeprg = "python3 " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(args.buf))
	end,
})
