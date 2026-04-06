Utils = require("utils")

vim.opt.colorcolumn = "80"

vim.opt.makeprg = "./build.sh"

vim.keymap.set('n', '<leader>k',
    function() Utils.search_in_zeal("cpp") end,
    { expr = true, silent = false })

vim.keymap.set('n', '<leader>c',
    Utils.toggle_colorcolumn,
    { expr = true, silent = false })
