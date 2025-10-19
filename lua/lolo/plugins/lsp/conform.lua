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
    c = { "clang_format" },
    cpp = { "clang_format" },
    rust = { "rustfmt" },
    go = { "gofmt" },
    python = { "black", "isort" },
    ruby = { "rubocop", "standardrb" },
    eruby = { "erb_format" }, -- << use our custom formatter below
  },

  format_on_save = function(bufnr)
    local file_name = vim.fn.expand("%:t")
    if file_name == ".condarc" or file_name:match("^%.") then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,

  formatters = {
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },

    -- Run the gem via Bundler so it’s always found in the project
    erb_format = {
      command = "bundle",
      args = { "exec", "erb-format", "--stdin" },
      stdin = true,
      cwd = function(ctx)
        local util = require("lspconfig.util")
        return util.root_pattern("Gemfile", ".git")(ctx.filename) or vim.loop.cwd()
      end,
    },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = "Format file or range (in visual mode)" })
