vim.pack.add({
	-- Themes
	{
		src = "https://codeberg.org/lifepillar/vim-solarized8",
		version = "neovim",
	},
	"https://github.com/rktjmp/lush.nvim",
	"https://github.com/zenbones-theme/zenbones.nvim",
	"https://github.com/ishan9299/nvim-solarized-lua",
	"https://github.com/craftzdog/solarized-osaka.nvim",

	-- Interface
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/folke/snacks.nvim",

	-- Filesystem
	"https://github.com/stevearc/oil.nvim",

	-- Completion and formatting
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = "v1",
	},
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/stevearc/conform.nvim",

	-- Version control
	"https://github.com/tpope/vim-fugitive",

	-- Language intelligence
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/kevinhwang91/promise-async",
	"https://github.com/kevinhwang91/nvim-ufo",
}, { confirm = false })

-- Appearance
require("plugins.colorscheme")
require("plugins.icons")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.snacks")

-- Filesystem
require("plugins.oil")

-- Editing
require("plugins.blink")
require("plugins.pairs")
require("plugins.conform")

-- Language intelligence
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.ufo")
