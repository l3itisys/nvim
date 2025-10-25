-- ~/.config/nvim/lua/lolo/plugins/blink-cmp.lua
vim.diagnostic.config({ virtual_text = false })

require("blink.cmp").setup({
  keymap = { preset = "default" },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = {
      auto_show = true,
      window = { border = "single" },
    },
    menu = {
      border = "single",
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- Add this snippets configuration
  snippets = {
    expand = function(snippet)
      require("luasnip").lsp_expand(snippet)
    end,
    active = function(filter)
      if filter and filter.direction then
        return require("luasnip").jumpable(filter.direction)
      end
      return require("luasnip").in_snippet()
    end,
    jump = function(direction)
      require("luasnip").jump(direction)
    end,
  },

  fuzzy = { implementation = "prefer_rust" },

  signature = {
    enabled = true,
    window = { border = "single" },
  },
})
