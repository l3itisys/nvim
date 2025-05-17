-- ~/.config/nvim/lua/lolo/plugins/tiny-inline-diagnostic.lua

local status, tiny_inline = pcall(require, "tiny-inline-diagnostic")
if not status then
  return
end

-- Setup tiny-inline-diagnostic first
tiny_inline.setup({
  -- Whether or not to show diagnostics inline
  enabled = true,

  -- Only show diagnostics on the current line (to reduce clutter)
  only_current_line = true,

  -- Highlight groups for each diagnostic severity
  highlights = {
    error = "DiagnosticFloatingError",
    warn = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },

  -- Defines how the diagnostic will be displayed
  format = "%d [%s]%e",

  -- Define prefix and suffix for the diagnostic message
  prefix = "",
  suffix = "",

  -- Window options
  win_opts = {
    -- Column offset from the initial diagnostic position
    offset_x = 2,

    -- Row offset from the initial diagnostic position
    offset_y = 0,

    -- Whether to show a thin border
    border = false,

    -- Virtual position means the floating window will not shift text to the right
    virt_position = true,

    -- Only show floating window if it can fit on the screen
    screen_fit = true,
  },
})

-- AFTER setting up tiny-inline-diagnostic, configure vim's diagnostics
vim.diagnostic.config({
  virtual_text = false, -- Completely disable vim's virtual text
  signs = true, -- Keep diagnostic signs in the gutter
  underline = true, -- Keep underlines
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Optionally add a keymap to toggle the diagnostics
vim.keymap.set("n", "<leader>td", function()
  tiny_inline.toggle()
end, { noremap = true, silent = true, desc = "Toggle inline diagnostics" })
