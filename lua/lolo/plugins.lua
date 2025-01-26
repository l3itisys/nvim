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

  -- LSP and Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

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
          model = "claude-3-sonnet-20240229",
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
      require('aider').setup({
        auto_manage_context = true,
        default_bindings = false
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

