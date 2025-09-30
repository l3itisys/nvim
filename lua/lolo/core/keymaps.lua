-- ~/.config/nvim/lua/lolo/core/keymaps.lua

vim.g.mapleader = " "

local keymap = vim.keymap

---------------------
-- General Keymaps
---------------------
-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>")

keymap.set("n", "<leader>to", ":tabnew<CR>")
keymap.set("n", "<leader>tx", ":tabclose<CR>")
keymap.set("n", "<leader>tn", ":tabn<CR>")
keymap.set("n", "<leader>tp", ":tabp<CR>")

-- Lazygit keymaps
keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open LazyGit" })
keymap.set("n", "<leader>lf", ":LazyGitCurrentFile<CR>", { desc = "LazyGit current file" })
keymap.set("n", "<leader>lc", ":LazyGitConfig<CR>", { desc = "LazyGit config" })

----------------------
-- Plugin Keybinds
--------------------
-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>")
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>")

-- Aider keymaps (if you want them here instead of which-key):
-- to open Aider default
keymap.set("n", "<leader>aa", function()
  require("aider").AiderOpen()
end, { noremap = true, silent = true, desc = "Open Aider default" })

-- to open Aider with custom args (example)
keymap.set("n", "<leader>ab", function()
  -- If you have some real param for "background" or remove this
  require("aider").AiderOpen("--background")
end, { noremap = true, silent = true, desc = "Aider Background" })

keymap.set("n", "<leader>a3", function()
  require("aider").AiderOpen("-3")
end, { noremap = true, silent = true, desc = "Open Aider GPT-3.5" })

-- Toggle indent guides
keymap.set("n", "<leader>ti", ":IndentToggle<CR>", { noremap = true, silent = true, desc = "Toggle indent guides" })

----------------------
-- Maven / SSV Test Commands
--------------------
-- Terminal
keymap.set("n", "<leader>tt", ":split | terminal<CR>", { desc = "Open terminal" })
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Maven shortcuts
keymap.set("n", "<leader>mt", ":split | terminal mvn test<CR>", { desc = "Maven: Run tests" })
keymap.set("n", "<leader>mc", ":split | terminal mvn clean test<CR>", { desc = "Maven: Clean & test" })
keymap.set("n", "<leader>mT", function()
  local test = vim.fn.input("Test class: ")
  if test ~= "" then
    vim.cmd("split | terminal mvn test -Dtest=" .. test)
  end
end, { desc = "Maven: Run specific test" })
