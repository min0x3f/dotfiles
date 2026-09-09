local autopairs = require("nvim-autopairs")

autopairs.setup({
	check_ts = true,
	disable_filetype = { "snacks_picker_input" },
	ts_config = {
		javascript = { "template_string" },
		lua = { "string" },
	},
})

-- Keep auto-pairing limited to braces for this configuration.
for _, rule in ipairs(vim.deepcopy(autopairs.config.rules)) do
	if rule.start_pair ~= "{" then
		autopairs.remove_rule(rule.start_pair)
	end
end
