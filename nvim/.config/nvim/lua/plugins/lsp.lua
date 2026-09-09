local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = {
		spacing = 8,
		severity = { min = vim.diagnostic.severity.ERROR },
	},
	signs = false,
	underline = true,
	update_in_insert = false,
	float = { border = "rounded", source = "if_many" },
})

local function on_attach(_, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("gD", vim.lsp.buf.declaration, "Go to declaration")
	map("gi", vim.lsp.buf.implementation, "Go to implementation")
	map("gt", vim.lsp.buf.type_definition, "Go to type definition")
	map("gr", vim.lsp.buf.references, "Find references")
	map("K", vim.lsp.buf.hover, "Hover documentation")
	map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
	map("<leader>lf", vim.lsp.buf.code_action, "Code action")
	map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
	map("]d", vim.diagnostic.goto_next, "Next diagnostic")
	map("<leader>le", vim.diagnostic.open_float, "Line diagnostics")
end

local function on_ruff_attach(client, bufnr)
	client.server_capabilities.hoverProvider = false
	on_attach(client, bufnr)

	local map = function(keys, kind, desc)
		vim.keymap.set("n", keys, function()
			vim.lsp.buf.code_action({ apply = true, context = { only = { kind } } })
		end, { buffer = bufnr, desc = desc })
	end

	map("<leader>cf", "source.fixAll.ruff", "Fix all Ruff issues")
	map("<leader>co", "source.organizeImports.ruff", "Organize imports")
end

vim.lsp.config("clangd", {
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy=false",
		"--query-driver=/opt/homebrew/bin/g++-15",
	},
	on_attach = on_attach,
})

vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("ruff", {
	capabilities = capabilities,
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	on_attach = on_ruff_attach,
})

vim.lsp.enable({ "clangd", "pyright", "lua_ls", "ruff" })
