-- ~/.config/nvim/lua/lolo/plugins/lsp/lint.lua

local status, lint = pcall(require, "lint")
if not status then
  return
end

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  -- Add more file types and linters as needed
}

-- Create an autocommand group for linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

-- Set up autocommands for triggering linting
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Add keymap for manual linting
vim.keymap.set("n", "<leader>ml", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })
