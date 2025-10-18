-- ~/.config/nvim/lua/lolo/plugins/avante.lua

local ok, avante = pcall(require, "avante")
if not ok then
  return
end

-- Optional helper; keep if you were using it before
pcall(function()
  require("avante_lib").load()
end)

avante.setup({
  -- Which provider Avante should use by default
  provider = "openai", -- "openai" (your Ollama endpoint) or "claude"

  -- Which provider powers inline suggestions
  auto_suggestions_provider = "openai",

  -- NEW: provider-specific configs go under `providers`
  providers = {
    -- OpenAI-compatible (your local Ollama + DeepSeek model)
    openai = {
      endpoint = "http://localhost:11434/v1",
      model = "deepseek-r1:7b-qwen-distill-q4_K_M",
      api_key = "ollama", -- placeholder; Ollama ignores it
      temperature = 0,
      max_tokens = 1024,
    },
  },

  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
})
