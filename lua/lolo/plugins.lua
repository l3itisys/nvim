-- ~/.config/nvim/lua/lolo/plugins.lua
return {
  -- Lua functions that many plugins use
  "nvim-lua/plenary.nvim",

  -- Colorscheme
  {
    "bluz71/vim-nightfly-guicolors",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme nightfly")
    end,
  },

  -- Treesitter (syntax highlighting, indenting, etc.)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "ruby",
          "html",
          "css",
          "scss",
          "javascript",
          "typescript",
          "tsx",
          "json",
          "yaml",
          "markdown",
          "bash",
          "vim",
          "vimdoc",
          "query",
        },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
      })
    end,
  },

  -- Tmux & split window navigation
  "christoomey/vim-tmux-navigator",

  -- Maximize and restore windows
  "szw/vim-maximizer",

  -- Essential plugins
  "tpope/vim-surround",
  "vim-scripts/ReplaceWithRegister",

  -- Commenting
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    init = function()
      vim.g.loaded = 1
      vim.g.loaded_netrwPlugin = 1
      vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
    end,
    opts = require("lolo.plugins.nvim-tree"),
  },

  -- Icons
  "kyazdani42/nvim-web-devicons",

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lolo.plugins.lualine")
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("lolo.plugins.nvim-cmp")
    end,
  },

  -- diagnostic
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("lolo.plugins.tiny-inline-diagnostic")
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    config = function()
      require("lolo.plugins.blink-cmp")
    end,
  },

  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- Optional dependency for floating window (you already have this)
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- Setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
    end,
  },

  -- LSP and Mason setup
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- list of servers for mason to install
        ensure_installed = {
          "ts_ls",
          "html",
          "cssls",
          "tailwindcss",
          "lua_ls",
          "emmet_ls",
          "pyright", -- Python support
          "clangd", -- C/C++ support
          "rust_analyzer", -- Rust support (optional)
          "gopls", -- Go support (optional)
        },
        automatic_installation = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lolo.plugins.lsp.lspconfig")
    end,
  },

  -- For code formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("lolo.plugins.lsp.conform")
    end,
  },

  -- For linting
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lolo.plugins.lsp.lint")
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("lolo.plugins.autopairs")
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("lolo.plugins.gitsigns")
    end,
  },

  -- Gen.nvim
  {
    "David-Kunz/gen.nvim",
    config = function()
      require("gen").setup({
        model = "stable-code:3b",
        display_mode = "split",
      })
    end,
  },

  -- Avante
  {
    "yetone/avante.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    build = "make",
    config = function()
      require("avante").setup({
        provider = "claude",
        claude = {
          model = "claude-3-5-sonnet-latest",
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("lolo.plugins.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- Official Aider plugin
  {
    "joshuavial/aider.nvim",
    config = function()
      require("aider").setup({
        auto_manage_context = true,
        default_bindings = false,
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
  },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("lolo.plugins.indent-blankline")
    end,
  },

  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
}
