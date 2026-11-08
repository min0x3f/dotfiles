local typst = require("config.typst")

vim.api.nvim_buf_create_user_command(0, "TypstWatch", typst.watch, { desc = "Watch this file and compile PDF on save" })
vim.api.nvim_buf_create_user_command(0, "TypstStop", typst.stop, { desc = "Stop watching this Typst file" })
vim.api.nvim_buf_create_user_command(0, "TypstOpen", typst.open, { desc = "Open the compiled PDF in Skim" })
