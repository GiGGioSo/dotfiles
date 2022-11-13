local g = vim.g
local o = vim.o
local opt = vim.opt

-- vim.cmd('syntax off')
-- vim.api.nvim_command('filetype plugin indent on')

o.termguicolors = true
-- o.background = 'dark'

o.syntax = false

-- Do not save when switching buffers
-- o.hidden = true

-- Better mouse support
opt.mouse = 'a'

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
-- o.scrolloff = 6

-- Better editor UI
o.number = true
o.numberwidth = 5
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true

-- Better editing experience
o.expandtab = true
o.smarttab = true
o.cindent = true
o.autoindent = true
o.wrap = true
o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 0 -- If negative, shiftwidth value is used
o.list = true
o.listchars = 'lead:·,trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'
-- o.listchars = 'eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,'
o.formatoptions = 'tnq'

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- BUG: this won't update the search count after pressing `n` or `N`
-- When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
-- o.lazyredraw = true

-- Better folds
-- o.foldlevelstart = 99
-- o.foldnestmax = 3
-- o.foldminlines = 1
-- opt.foldmethod='expr'
-- opt.foldexpr='nvim_treesitter#foldexpr()'
-- automatically open all folds opening a file
-- vim.cmd [[ autocmd BufReadPost,FileReadPost * normal zR ]]

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '

-- Themes
-- Possible themes: (recommended is a base16-* one)
--      nightfox, dayfox, dawnnfox, duskfox, nordfox, terafox, carbonfox
--      onedarkpro
--      monokai, monokai_pro, monokai_soda, monokai_ristretto
--      base16-* NEEDED IF YOU WANT TO USE 'base16' FOR LUALINE
local colorscheme = 'base16-gruvbox-material-dark-medium'
-- local colorscheme = 'base16-monokai'
local _, _ = pcall(vim.cmd, 'colorscheme '..colorscheme)

opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Custom filetypes
vim.cmd [[ au BufRead,BufNewFile *.vs set filetype=glsl ]]
vim.cmd [[ au BufRead,BufNewFile *.fs set filetype=glsl ]]
