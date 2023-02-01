
local g = vim.g
local o = vim.o
local opt = vim.opt

-- ### Editor settings ###

-- Use all colors
o.termguicolors = true

o.background = 'dark'

-- Mouse support
opt.mouse = 'a'

-- Line number options
opt.number = true
opt.relativenumber = true
o.numberwidth = 4

-- Ignore case when searching
opt.ignorecase = true
-- unless the search term has an uppercase letter
opt.smartcase = true

-- Make nvim and OS clipboard play together
o.clipboard = 'unnamedplus'

-- Wrap lines when they are too long
opt.wrap = true

-- Indentation options
opt.breakindent = true

-- Tab options
opt.tabstop = 4
opt.expandtab = true
opt.shiftwidth = 4

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 6

-- Better completition
o.completeopt = 'menuone,noselect'

-- Decrease update times
o.timeoutlen = 500
o.updatetime = 200

-- Remove backups
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true

-- Better buffer splitting
o.splitright = true
o.splitbelow = true



-- ### Keybindings ###
g.mapleader = ' '

-- Deleting with 'x' doesn't overwrite the copy buffer
vim.keymap.set({'n', 'x'}, 'x', '"_x')
-- Pasting into a selection with '<leader>p' makes it so you don't overwrite the copybuffer
vim.keymap.set('v', '<leader>p', '"_dP')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ### Autocommands ###
local augroup = vim.api.nvim_create_augroup('user_cmds', {clear = true})

-- Quit with 'q' from man and help menus
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'help', 'man'},
    group = augroup,
    desc = 'Use q to close the window',
    command = 'nnoremap <buffer> q <cmd>quit<cr>'
})
