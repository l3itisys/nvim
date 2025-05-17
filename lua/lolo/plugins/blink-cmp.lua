-- Replace your ~/.config/nvim/lua/lolo/plugins/blink-cmp.lua with this:

-- Make sure virtual_text is disabled for tiny-inline-diagnostic
vim.diagnostic.config({ virtual_text = false })

require("blink.cmp").setup({
  -- Use the default preset keymap (C-y to accept, C-n/C-p to navigate)
  keymap = { preset = "default" },

  appearance = {
    -- Default for Nerd Font Mono to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = {
      auto_show = true, -- Shows documentation automatically
      window = { border = "single" }, -- Add border for better visibility
    },
    menu = {
      border = "single", -- Add border to completion menu
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- Use the recommended Rust fuzzy matcher for better performance
  fuzzy = { implementation = "prefer_rust" },

  -- Enable signature help for function parameters with border
  signature = {
    enabled = true,
    window = { border = "single" },
  },
})
