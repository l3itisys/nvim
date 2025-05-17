-- ~/.config/nvim/lua/lolo/plugins/lsp/conform.lua

local status, conform = pcall(require, "conform")
if not status then
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
  },

  -- Set up format-on-save
  format_on_save = function(bufnr)
    -- Skip formatting for certain file types
    local file_type = vim.bo[bufnr].filetype
    local file_name = vim.fn.expand("%:t")

    -- Skip formatting for .condarc and other config files
    if file_name == ".condarc" or file_name:match("^%.") then
      return
    end

    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,

  -- Customize formatters
  formatters = {
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
  },
})

-- Add format keymap
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
