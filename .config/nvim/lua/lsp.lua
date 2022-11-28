---
-- Keybindings with autocmd
---

vim.api.nvim_create_autocmd('User', {
    pattern = 'LspAttached',
    desc = 'LSP actions',
    callback = function()
        local function map(m, k, v)
            vim.keymap.set(m, k, v, { silent = true })
        end
        -- Displays hover information about the symbol under the cursor
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- Jump to the definition
        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

        -- Jump to declaration
        map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Lists all the implementations for the symbol under the cursor
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

        -- Jumps to the definition of the type symbol
        map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

        -- Lists all the references 
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

        -- Displays a function's signature information
        map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        -- Renames all references to the symbol under the cursor
        map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

        -- Selects a code action available at the current cursor position
        map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        map('x', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

        -- Show diagnostics in a floating window
        map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

        -- Move to the previous diagnostic
        map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

        -- Move to the next diagnostic
        map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        -- Disable and enable diagnostics
        map('n', '<leader>hd', '<cmd>lua vim.diagnostic.disable()<cr>')
        map('n', '<leader>sd', '<cmd>lua vim.diagnostic.enable()<cr>')
    end,
})

---
-- Diagnostics
---

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = '',
    })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    -- spacing=15,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = 'rounded'}
)

-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
-- ]])
---
-- Language servers config
---

local lsp_defaults = {
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    ),
    on_attach = function(client, bufnr)
        vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
    end
}

local lspconfig = require('lspconfig')
lspconfig.util.default_config = vim.tbl_deep_extend('force', lspconfig.util.default_config, lsp_defaults)

-- Bash language server
lspconfig.bashls.setup({})
-- C++ language server
lspconfig.clangd.setup({})
-- CMake language server
lspconfig.cmake.setup({})
-- Docker language server
lspconfig.dockerls.setup({})
-- GLSL language server
-- lspconfig.glslls.setup({}) -- NOT READY YET, IT HAS NO FUNCTIONALITY
-- HTML language server
lspconfig.html.setup({})
-- Java language server
lspconfig.jdtls.setup({})
-- JSON language server
lspconfig.jsonls.setup({})
-- LaTeX, Markdown and others language server
lspconfig.ltex.setup({})
-- Python language server
lspconfig.pyright.setup({})
-- Lua language server
lspconfig.sumneko_lua.setup({
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
            -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
            -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
          -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    -- on_attach = function(client, bufnr)
    --     lspconfig.util.default_config.on_attach(client, bufnr)
    -- end
})
-- Vim-script language server
lspconfig.vimls.setup({})
-- YAML language server
lspconfig.yamlls.setup({})
-- Scheme / Racket language server
lspconfig.racket_langserver.setup({})
-- Rust lang server
lspconfig.rust_analyzer.setup({})
-- Assembly lang server
-- lspconfig.asm_lsp.setup({
--     filetypes = {
--         "asm", "vmasm", "s"
--     }
-- })

