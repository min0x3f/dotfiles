local opt = vim.opt

-- Display
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.showcmd = true
opt.ruler = true
opt.title = true

-- Theme and cursor
opt.termguicolors = true
opt.background = "light"
opt.cursorline = false
opt.guicursor = "a:block"

-- Gutter and command line
opt.signcolumn = "no"
opt.cmdheight = 1
opt.laststatus = 3
opt.showmode = false

-- Clipboard
opt.clipboard = { "unnamed", "unnamedplus" }

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Indentation
opt.smarttab = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = false
opt.breakindent = true
opt.backspace = { "indent", "eol", "start" }

-- Whitespace and wrapping
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", extends = "▶", precedes = "◀", nbsp = "␣" }

-- Folds
opt.foldenable = true
opt.foldlevelstart = 99

-- Files
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true

-- Windows and scrolling
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8

-- Responsiveness and confirmations
opt.updatetime = 250
opt.timeoutlen = 300
opt.confirm = true
