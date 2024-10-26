local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require("ibl.hooks")

-- Create highlight groups
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

-- Store the enabled state
local enabled = true

-- Configure indent-blankline
require("ibl").setup({
    enabled = enabled,
    scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        injected_languages = true,
        highlight = highlight,
        priority = 500,
    },
    indent = {
        char = "▏",
        tab_char = "▏",
        highlight = highlight,
        smart_indent_cap = true,
        priority = 1,
    },
    whitespace = {
        remove_blankline_trail = true,
    },
    exclude = {
        filetypes = {
            "help",
            "dashboard",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
        buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
        },
    },
})

-- Hook up with rainbow-delimiters
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

-- Add command to toggle indent guides
vim.api.nvim_create_user_command("IndentToggle", function()
    enabled = not enabled
    local ibl = require("ibl")
    if enabled then
        ibl.update({ enabled = true })
    else
        ibl.update({ enabled = false })
    end
end, {})

-- Create autocommands group
local indent_group = vim.api.nvim_create_augroup("IndentBlanklineAutogroup", { clear = true })

-- Disable for some filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = indent_group,
    pattern = { "alpha", "dashboard" },
    callback = function()
        local ibl = require("ibl")
        ibl.update({ enabled = false })
    end,
})

-- Optional: Different indent settings for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = indent_group,
    pattern = { "python", "lua" },
    callback = function()
        local ibl = require("ibl")
        ibl.update({
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
            },
        })
    end,
})
