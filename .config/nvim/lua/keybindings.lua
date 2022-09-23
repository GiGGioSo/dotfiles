local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

local function del(m, k)
    vim.keymap.del(m, k, {silent = true})
end

-- Exit insert mode with alt+c
map({'i', 'n', 'v', 'o'}, '<A-c>', '<ESC>')

-- Go to end of the line with L
map({'n', 'v', 'o'}, 'L', '$')

-- Go to start of the line with H
map({'n', 'v', 'o'}, 'H', '^')

-- Save with ctrl+s
map({'n', 'i', 'v', 'o'}, '<C-s>', '<CMD>w<CR>')

-- Move to next tab
map({'n', 'i', 'v'}, '<C-l>', '<CMD>BufferLineCycleNext<CR>')

-- Move to previous tab
map({'n', 'i', 'v'}, '<C-h>', '<CMD>BufferLineCyclePrev<CR>')

-- Close current tab
-- map({'n', 'i', 'v', 'o'}, '<C-w>', '<CMD>bdelete<CR>')

-- Telescope keybindings
map('n', '<leader>ff', '<CMD>Telescope find_files<CR>')
map('n', '<leader>fg', '<CMD>Telescope live_grep<CR>')
map('n', '<leader>fb', '<CMD>Telescope buffers<CR>')
map('n', '<leader>fh', '<CMD>Telescope help_tags<CR>')
-- Some other keybinding are present in the Telescope configuration, in the plugins.lua file

-- Nvim-tree keybindings
map({'n', 'i', 'v'}, '<C-n>', '<CMD>NvimTreeToggle<CR>')
map('n', '<leader>e', '<CMD>NvimTreeFocus<CR>')

