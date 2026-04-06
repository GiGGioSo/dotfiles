
local g = vim.g
local o = vim.o
local opt = vim.opt

-- Otherwise nvim freezes on windows
o.keywordprg = ':help'

-- ### Editor settings ###

-- Use all colors
o.termguicolors = true

-- Color scheme
vim.cmd(':colorscheme base16-gruvbox-material-dark-hard')
o.background = 'dark'

-- Mouse support
opt.mouse = 'a'

-- Autoread
vim.opt.autoread = true 

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

-- Folding options
-- Change fold colors
-- vim.cmd(':highlight Folded guibg=Gray guifg=DarkRed')

-- Better finding
opt.path:append("**")

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

-- Automatically save the current file when going into normal mode
vim.keymap.set('n', '<leader>w', '<CMD>w<CR>')

-- Exit from terminal mode
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Consente a Neovim di leggere un file di configurazione locale per progetto
vim.opt.exrc = true
-- vim.opt.secure = true  -- sicurezza extra: limita i comandi considerati pericolosi nei file locali

-- ### Paq plugin manager
require "paq" {
    "savq/paq-nvim", -- Let Paq manage itself
    "RRethy/nvim-base16", -- Colorschemes
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}

-- ### nvim-treesitter
require("nvim-treesitter").setup {
    install_dir = vim.fn.stdpath("data") .. "/site",
}
vim.treesitter.language.register('objc', { 'objcpp' })
require("nvim-treesitter").install {
    "svelte",
    "html",
    "css",
    "javascript",
    "typescript",
    "c",
    "cpp",
    "cuda",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "objc",
    "python",
    "proto",
}

-- ### Autocommands ###
local augroup = vim.api.nvim_create_augroup('user_cmds', {clear = true})

-- Quit with 'q' from man and help menus
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'help', 'man'},
    group = augroup,
    desc = 'Use q to close the window',
    command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

-- ### TREE-SITTER-BASED FOLDING & CLEAN UI (Simboli a sinistra) ###

-- Configurazione globale per tutti i server (*)
-- Qui abilitiamo esplicitamente il supporto al folding range
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },
})

-- Opzioni di base
opt.foldcolumn = '0' 
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Motore Tree-sitter
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldnestmax = 20

-- 5. Testo del fold (come richiesto, pulito)
function _G.custom_fold_text()
    local fs = vim.v.foldstart
    local fe = vim.v.foldend
    local line = vim.fn.getline(fs)
    local line_count = fe - fs + 1
    return line .. " ... (" .. line_count .. " linee)"
end

opt.foldtext = "v:lua.custom_fold_text()"

-- ### LSP ACTIVATION
vim.lsp.enable({
    "gopls",
    "clangd",
    "basedpyright",
})

-- ## Autocomplete options
vim.opt.completeopt = { "menu", "menuone", "preview" }

vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
        if vim.fn.pumvisible() == 0 then
            vim.cmd("silent! pclose")
        end
    end,
})

-- ## Better LSP hover popup
do
    local hover = vim.lsp.buf.hover
    local util = vim.lsp.util

    vim.lsp.buf.hover = function()
        hover({
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.6),
            max_height = math.floor(vim.o.lines * 0.5),
        })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        util.hover,
        {
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.6),
            max_height = math.floor(vim.o.lines * 0.5),
        }
    )
end

-- ## Make hover window nicer
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        local win = vim.fn.bufwinid(args.buf)
        if win == -1 then
            return
        end

        local config = vim.api.nvim_win_get_config(win)

        -- floating window
        if config.relative ~= "" then
            vim.wo[win].wrap = false
            vim.wo[win].linebreak = false
            vim.wo[win].signcolumn = "no"
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
        end
    end
})

-- ## Explicit Hover keymap
vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
    float = {
        border = "rounded",       -- Bordi arrotondati
        source = "always",        -- Mostra la sorgente (lsp)
        header = "",              -- Nessun header
        prefix = " ",             -- Padding sinistro
        focusable = true,         -- Rende possibile interagire col popup
        style = "minimal",        -- Stile pulito
    },
})

-- ## Signature Help popup più bello
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    if err ~= nil or not result or not result.signatures or #result.signatures == 0 then
        return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local buf = vim.api.nvim_get_current_buf()

    local lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result)
    lines = vim.lsp.util.trim_empty_lines(lines)

    -- opzioni personalizzate per look coerente
    local float_opts = {
        border = "rounded",
        focusable = true,
        style = "minimal",
        pad_left = 1,
        pad_right = 1,
        pad_top = 0,
        pad_bottom = 0,
        max_width = math.floor(vim.o.columns * 0.7), -- larghezza massima ragionevole
    }

    vim.lsp.util.open_floating_preview(lines, "markdown", float_opts)
end

-- ## GRR toggle workspace-only vs global
local function filter_workspace(locations)
    local workspace_folders = vim.lsp.buf.list_workspace_folders()
    local filtered = {}
    for _, loc in ipairs(locations) do
        local path = vim.uri_to_fname(loc.uri)
        for _, folder in ipairs(workspace_folders) do
            if path:sub(1, #folder) == folder then
                table.insert(filtered, loc)
                break
            end
        end
    end
    return filtered
end
-- GRR: references workspace only
vim.keymap.set("n", "grr", function()
    local params = vim.lsp.util.make_position_params(0)  -- 0 = current window
    params.context = { includeDeclaration = true }      -- add includeDeclaration

    vim.lsp.buf_request(0, "textDocument/references", params, function(err, result)
        if err or not result then return end
        local filtered = filter_workspace(result)
        if #filtered == 0 then
            print("No references in current workspace")
            return
        end
        vim.fn.setqflist(vim.lsp.util.locations_to_items(filtered))
        vim.cmd("copen")
    end)
end, { noremap = true, silent = true })

-- GRR toggle: global
vim.keymap.set("n", "gRR", function()
    vim.lsp.buf.references()
end, { noremap = true, silent = true })

-- ## Navigate to next/previous diagnostic + show popup
vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev()
    vim.diagnostic.open_float()
end, { noremap = true, silent = true })

vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next()
    vim.diagnostic.open_float()
end, { noremap = true, silent = true })
