local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  return
end

mason.setup()
mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = {
    "ts_ls", -- replaced "tsserver"
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "emmet_ls",
    "pyright",
    "clangd",
    "rust_analyzer",
    "gopls",
    "jdtls",
    "ruby_lsp",
  },
  automatic_installation = true,
})
