-- ~/.config/nvim/lua/lolo/plugins/lsp/lspconfig.lua
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
local util = require("lspconfig.util")
if not lspconfig_status then
  return
end

local util = require("lspconfig.util")
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
local capabilities = (function()
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink and blink.get_lsp_capabilities then
    return blink.get_lsp_capabilities()
  end
  local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp and cmp.default_capabilities then
    return cmp.default_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end)()

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
      -- Try common Lua roots; fall back to your Neovim config directory
      return util.root_pattern(".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git")(fname)
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

  -- Ruby (Rails) — prefer Bundler if Gemfile exists
  ruby_lsp = {
    cmd = { "ruby-lsp" }, -- default; may be overwritten by on_new_config
    on_new_config = function(new_config, root_dir)
      if vim.fn.executable("bundle") == 1 and vim.fn.filereadable(root_dir .. "/Gemfile") == 1 then
        new_config.cmd = { "bundle", "exec", "ruby-lsp" }
      else
        -- try Mason’s installed binary if present, else PATH
        local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/ruby-lsp"
        if vim.fn.executable(mason_bin) == 1 then
          new_config.cmd = { mason_bin }
        else
          new_config.cmd = { "ruby-lsp" }
        end
      end
    end,
    init_options = {
      formatter = "auto", -- uses standard/rubocop if present
      linters = { "auto" },
    },
    filetypes = { "ruby" },
    root_dir = function(fname)
      return util.root_pattern("Gemfile", ".git")(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()
    end,
  },
}

-- ================================
-- Prefer the NEW Neovim 0.11+ API
-- ================================
local has_newapi = vim.lsp and vim.lsp.config and vim.lsp.enable
if has_newapi then
  -- Register all servers
  for name, conf in pairs(servers) do
    conf.capabilities = capabilities
    conf.on_attach = on_attach
    vim.lsp.config(name, conf)
  end

  -- Enable Mason-installed servers first (if Mason is present)
  local enabled = {}
  local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if mason_ok then
    for _, name in ipairs(mason_lspconfig.get_installed_servers()) do
      table.insert(enabled, name)
    end
  end

  -- Also enable any servers you defined that Mason didn't install (e.g. ruby_lsp via Bundler)
  local seen = {}
  for _, n in ipairs(enabled) do
    seen[n] = true
  end
  for name, _ in pairs(servers) do
    if not seen[name] then
      table.insert(enabled, name)
    end
  end

  vim.lsp.enable(enabled)
else
  -- ===== Legacy path using lspconfig (Neovim < 0.11) =====
  local installed = {}
  local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if mason_ok then
    for _, name in ipairs(mason_lspconfig.get_installed_servers()) do
      installed[name] = true
      local cfg = servers[name] or {}
      cfg.capabilities = capabilities
      cfg.on_attach = on_attach
      if lspconfig[name] then
        lspconfig[name].setup(cfg)
      end
    end
  end
  -- Also setup any servers not installed via Mason (e.g. ruby_lsp from Bundler)
  for name, cfg in pairs(servers) do
    if not installed[name] and lspconfig[name] then
      cfg.capabilities = capabilities
      cfg.on_attach = on_attach
      lspconfig[name].setup(cfg)
    end
  end
end

-- =========================================================
-- Extra: forcibly start ruby-lsp on Ruby buffers if needed
-- (no-op if already attached; avoids Mason API calls)
-- =========================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby" },
  callback = function(args)
    if #vim.lsp.get_clients({ name = "ruby_lsp", bufnr = args.buf }) > 0 then
      return
    end

    local fname = vim.api.nvim_buf_get_name(args.buf)
    local root = util.root_pattern("Gemfile", ".git")(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()

    local cmd
    if vim.fn.executable("bundle") == 1 and vim.fn.filereadable(root .. "/Gemfile") == 1 then
      cmd = { "bundle", "exec", "ruby-lsp" }
    else
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/ruby-lsp"
      if vim.fn.executable(mason_bin) == 1 then
        cmd = { mason_bin }
      else
        cmd = { "ruby-lsp" }
      end
    end

    vim.lsp.start({
      name = "ruby_lsp",
      cmd = cmd,
      root_dir = root,
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
})
