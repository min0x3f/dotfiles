local group = vim.api.nvim_create_augroup("scratch-make", { clear = true })

local function set_cpp_makeprg(args)
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
    vim.fn.shellescape(vim.fn.stdpath("config") .. "/make/cpp-practice.mk"),
    " SOURCE=",
    vim.fn.shellescape(source),
  })
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "cpp", "cxx", "cc" },
  callback = set_cpp_makeprg,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function(args)
    vim.bo[args.buf].makeprg = "python3 " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(args.buf))
  end,
})
