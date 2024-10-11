-- Load Avante library
require("avante_lib").load()

-- Configure Avante
require("avante").setup({
	--	debug = true,
	provider = "claude",
	auto_suggestions_provider = "claude",
	claude = {
		endpoint = "https://api.anthropic.com",
		model = "claude-3-5-sonnet-20240620",
		temperature = 0,
		max_tokens = 4096,
	},
	behaviour = {
		auto_suggestions = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = true,
		support_paste_from_clipboard = false,
	},
	-- Add any other configurations as needed
})
