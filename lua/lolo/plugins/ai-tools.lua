-- ~/.config/nvim/lua/lolo/plugins/ai-tools.lua

local M = {}

-- Helper functions for AI commands
local function quick_help()
  vim.cmd('botright split')
  vim.cmd('resize 15')
  vim.cmd('Gen Quick')
  vim.cmd('wincmd k')
end

local function add_doc()
  vim.cmd('botright split')
  vim.cmd('resize 15')
  vim.cmd('Gen Doc')
  vim.cmd('wincmd k')
end

local function improve_code()
  vim.cmd('botright split')
  vim.cmd('resize 15')
  vim.cmd('Gen Improve')
  vim.cmd('wincmd k')
end

function M.setup()
  -- Local LLM Configuration (Ollama + gen.nvim)
  require("gen").setup({
    model = "stable-code:3b",
    display_mode = "split",
    show_prompt = true,
    show_model = true,
    no_auto_close = true,
    init = function()
      vim.cmd('wincmd J')
      vim.cmd('resize 15')
      vim.wo.wrap = true
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.bo.modifiable = true
    end,
    prompts = {
      ["Quick"] = {
        provider = "stable-code:3b",
        prompt = "Explain this code snippet concisely and technically, focusing on its purpose...\n```$filetype\n$text\n```",
      },
      ["Doc"] = {
        provider = "stable-code:3b",
        prompt = "Add professional documentation for this code...\n```$filetype\n$text\n```",
      },
      ["Improve"] = {
        provider = "stable-code:3b",
        prompt = "Suggest improvements for this code focusing on performance...\n```$filetype\n$text\n```",
      },
    },
    window = {
      border = "single",
      title = "AI Assistant",
      title_pos = "center",
    },
  })

  -- Set up which-key with navigation hints
  local ok, wk = pcall(require, "which-key")
  if ok then
    local mappings = {
      l = {
        name = "Local LLM",
        q = { quick_help, "Quick Help" },
        d = { add_doc, "Add Documentation" },
        i = { improve_code, "Improve Code" },
      },
      a = {
        name = "Aider",
        -- Use AiderOpen (Lua function) from the aider.nvim plugin
        a = {
          function()
            -- No args means default `aider` CLI
            require("aider").AiderOpen()
          end,
          "Open Aider (Default)"
        },
        b = {
          function()
            -- Possibly pass some custom args if you have them,
            -- else remove this if plugin doesn't define "background"
            require("aider").AiderOpen("--background")
          end,
          "Aider Background"
        },
        ["3"] = {
          function()
            -- Example passing -3 if you want GPT-3.5
            require("aider").AiderOpen("-3")
          end,
          "Open Aider GPT-3.5"
        },
      },
      t = {
        name = "Toggle",
        i = { ":IndentToggle<CR>", "Toggle indent guides" },
      },
    }

    local opts = {
      prefix = "<leader>",
      mode = "n",
    }
    wk.register(mappings, opts)
  end
end

return M

