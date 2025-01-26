-- ~/.config/nvim/init.lua

-- Load Lazy.nvim and your plugins
require("lolo.config.lazy")

-- Load your core configurations
require("lolo.core.options")
require("lolo.core.keymaps")
require("lolo.core.colorscheme")
require("lolo.core.utils")

-- Load AI tools configuration
require("lolo.plugins.ai-tools").setup()

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Helper function for Aider buffer reloading
function _G.ReloadBuffer()
  local temp_sync_value = vim.g.aider_buffer_sync
  vim.g.aider_buffer_sync = 0
  vim.api.nvim_exec2('e!', {output = false})
  vim.g.aider_buffer_sync = temp_sync_value
end
