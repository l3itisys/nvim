-- ~/.config/nvim/lua/lolo/plugins/blink-cmp.lua
-- Make sure virtual_text is disabled for tiny-inline-diagnostic
vim.diagnostic.config({ virtual_text = false })

require("blink.cmp").setup({
  -- Use the default preset keymap (similar to built-in completions with C-y to accept)
  keymap = { preset = "default" },

  appearance = {
    -- Default for Nerd Font Mono to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = { auto_show = true }, -- Changed from default (false) to match your preferences
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- Use the recommended Rust fuzzy matcher for better performance
  fuzzy = { implementation = "prefer_rust_with_warning" },

  -- Enable signature help for function parameters
  signature = { enabled = true },
})
