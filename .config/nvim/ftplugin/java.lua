Utils = require("utils")

local g = vim.g
local o = vim.o
local opt = vim.opt

-- Folding options
opt.foldmethod = 'indent'
opt.foldnestmax = 2

-- Change fold colors
-- vim.cmd(':highlight Folded guibg=Gray guifg=DarkRed')

opt.colorcolumn = "80"

opt.path:append("/usr/lib/jvm/default/lib/src/java.base/**")

opt.makeprg = "javac %"

vim.keymap.set('n', '<leader>k',
    function() Utils.search_in_zeal("java17") end,
    { expr = true, silent = false })

vim.keymap.set('n', '<leader>c',
    Utils.toggle_colorcolumn,
    { expr = true, silent = false })

