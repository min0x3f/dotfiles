vim.api.nvim_create_user_command("Wq", function()
  vim.cmd.write()
  vim.cmd.bdelete()
end, {
  desc = "Write and delete current buffer",
})
