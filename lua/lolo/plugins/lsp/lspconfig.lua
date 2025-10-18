-- ~/.config/nvim/lua/lolo/plugins/lsp/lspconfig.lua
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- show references
  keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- go to declaration
  keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- go to definition
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- code actions
  keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- smart rename
  keymap.set("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- diagnostics (line)
  keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- diagnostics (cursor)
  keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

  -- typescript specific keymaps
  if client.name == "ts_ls" then
    keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
    keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
    keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = false, -- We'll let tiny-inline-diagnostic handle this
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Server-specific configurations
local servers = {
  html = {},
  ts_ls = {},
  cssls = {},
  tailwindcss = {},

  -- Emmet (add eruby for Rails templates)
  emmet_ls = {
    filetypes = {
      "html",
      "eruby",
      "typescriptreact",
      "javascriptreact",
      "css",
      "sass",
      "scss",
      "less",
      "svelte",
    },
  },

  lua_ls = {
    single_file_support = true,
    root_dir = function(fname)
      local u = require("lspconfig.util")
      -- Try common Lua roots; fall back to your Neovim config directory
      return u.root_pattern(".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git")(fname)
        or vim.fn.stdpath("config")
    end,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
          checkThirdParty = false,
          -- Optional: help the server see your Neovim runtime & config
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        completion = { callSnippet = "Replace" },
      },
    },
  },

  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          diagnosticMode = "workspace",
          inlayHints = { variableTypes = true, functionReturnTypes = true },
        },
      },
    },
  },

  -- C/C++ Language Server
  clangd = {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = function()
      return vim.fs.dirname(vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1])
    end,
    settings = {
      clangd = {
        arguments = {
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      },
    },
  },

  -- Rust Language Server (optional)
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        diagnostics = { enable = true },
      },
    },
  },

  -- Go Language Server (optional)
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },

  -- Ruby (Rails) — prefer bundle exec if Gemfile exists, else mason/global binary
  ruby_lsp = (function()
    local use_bundle = (vim.fn.executable("bundle") == 1) and (vim.fs.find("Gemfile", { upward = true })[1] ~= nil)
    local cmd
    if use_bundle then
      cmd = { "bundle", "exec", "ruby-lsp" }
    elseif vim.fn.executable("ruby-lsp") == 1 then
      cmd = { "ruby-lsp" }
    else
      cmd = { "ruby-lsp" } -- will still error if not installed; see notes below
    end
    return {
      cmd = cmd,
      init_options = {
        formatter = "auto", -- uses standard/rubocop if present
        linters = { "auto" },
      },
      filetypes = { "ruby" },
      root_dir = function(fname)
        return vim.fs.root(fname, { "Gemfile", ".git" }) or vim.loop.cwd()
      end,
    }
  end)(),
}

-- ================================
-- Prefer the NEW Neovim 0.11+ API
-- ================================
local has_newapi = vim.lsp and vim.lsp.config and vim.lsp.enable
if has_newapi then
  local to_enable = {}
  for name, conf in pairs(servers) do
    conf.capabilities = capabilities
    conf.on_attach = on_attach
    vim.lsp.config(name, conf) -- register
    table.insert(to_enable, name)
  end
  vim.lsp.enable(to_enable) -- start them
else
  -- ===== Your original (legacy) setup using lspconfig =====
  local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
  if mason_lspconfig_status then
    local available_servers = mason_lspconfig.get_installed_servers()
    for _, server_name in ipairs(available_servers) do
      local server_config = servers[server_name] or {}
      server_config.capabilities = capabilities
      server_config.on_attach = on_attach
      if lspconfig[server_name] then
        lspconfig[server_name].setup(server_config)
      end
    end
  else
    for server_name, server_config in pairs(servers) do
      server_config.capabilities = capabilities
      server_config.on_attach = on_attach
      if lspconfig[server_name] then
        lspconfig[server_name].setup(server_config)
      end
    end
  end
end
