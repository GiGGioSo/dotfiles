local function map(m, k, v, opts)
    local options = {silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.keymap.set(m, k, v, options)
end

local function del(m, k)
    vim.keymap.del(m, k, {silent = true})
end


-- Exit insert mode with alt+c
map({'i', 'n', 'v', 'o', 't'}, '<A-c>', '<ESC>')

-- Go to end of the line with L
map({'n', 'v', 'o'}, 'L', '$')
-- Go to start of the line with H
map({'n', 'v', 'o'}, 'H', '^')

-- Move to next tab
map({'n', 'i', 'v'}, '<C-l>', '<CMD>BufferLineCycleNext<CR>')
-- Move to previous tab
map({'n', 'i', 'v'}, '<C-h>', '<CMD>BufferLineCyclePrev<CR>')

-- Better Ctrl-d and Ctrl-u
map({'n', 'v'}, '<C-d>', '<C-d>zz')
map({'n', 'v'}, '<C-u>', '<C-u>zz')

-- NON FUNZIONANO!!!!
-- Paste without without yanking the replaced part
-- map({'x'}, '<leader>p', '<CMD>"0p<CR>', {noremap = true})

-- Close current tab
map({'n', 'i', 'v', 'o'}, '<C-q>', '<CMD>bdelete<CR>')

-- Telescope keybindings
map('n', '<leader>ff', '<CMD>Telescope find_files<CR>')
map('n', '<leader>fg', '<CMD>Telescope live_grep<CR>')
map('n', '<leader>fb', '<CMD>Telescope buffers<CR>')
map('n', '<leader>fh', '<CMD>Telescope help_tags<CR>')
-- Some other keybinding are present in the Telescope configuration, in the plugins.lua file

-- Nvim-tree keybindings
map({'n', 'i', 'v'}, '<C-n>', '<CMD>NvimTreeToggle<CR>')
map('n', '<leader>e', '<CMD>NvimTreeFocus<CR>')

