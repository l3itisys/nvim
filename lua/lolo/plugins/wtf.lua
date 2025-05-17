-- ~/.config/nvim/lua/lolo/plugins/wtf.lua

local status, wtf = pcall(require, "wtf")
if not status then
  return
end

wtf.setup({
  -- Directory for storing chat files
  chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/wtf/chats",

  -- Default AI popup type
  popup_type = "popup", -- "popup", "horizontal", or "vertical"

  -- Set your OpenAI API key (optional)
  -- openai_api_key = "YOUR_API_KEY", -- Or set via OPENAI_API_KEY env variable

  -- ChatGPT Model (if using OpenAI)
  openai_model_id = "gpt-3.5-turbo",

  -- Send code as well as diagnostics for better context
  context = true,

  -- Set your preferred language for the response
  language = "english",

  -- Additional instructions to send to the AI
  additional_instructions = "Provide concise explanations and solutions",

  -- Default search engine, can be overridden when calling the search command
  search_engine = "google", -- "google", "duck_duck_go", "stack_overflow", "github", etc.

  -- Optional callbacks
  hooks = {
    request_started = nil,
    request_finished = nil,
  },
})

-- Optional: Add to lualine if you want status indicator
-- In your lualine config, you can add this to a section:
--
-- require('lualine').setup({
--   sections = {
--     lualine_x = { wtf.get_status }
--   }
-- })
