-- Ensure avante is loaded
local status, avante = pcall(require, "avante")
if not status then
  return
end

-- Load Avante library
require("avante_lib").load()

avante.setup({
  -- ================ CHOOSE ONE ================
  provider = "openai",  -- Switch to "openai" if you want to use Ollama or "claude"
  -- ============================================

  auto_suggestions_provider = "openai", -- or "openai" if using openai provider or "claude"

  -- Claude config (Anthropic)
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-5-sonnet-20240620",
    temperature = 0,
    max_tokens = 4096,
  },

  -- OpenAI config (Local Ollama w/ DeepSeek)
  openai = {
    endpoint = "http://localhost:11434/v1",  -- the local openai-like server
    model = "deepseek-r1:7b-qwen-distill-q4_K_M",
    api_key = "ollama",  -- just a placeholder, Ollama ignores it
    temperature = 0,
    max_tokens = 1024,
  },

  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
})

