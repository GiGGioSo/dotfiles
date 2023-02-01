-- Here I will insert all my plugins, using packer

-- TODO 

return require('packer').startup({
    function(use)
        --  Plugins to add:
        --
        --  Plugins to configure:
        --      https://github.com/voldikss/vim-floaterm
        --      'echasnovski/mini.nvim': maybe better than dashboard-nvim
        --      'glepnir/dashboard-nvim': configure into something like the github example
        --

        -- Package Manager
        use('wbthomason/packer.nvim')

        -- Utils
        use('nvim-lua/plenary.nvim')

        -- LSP, linter and stuff manager
        use {
            'williamboman/mason.nvim',
            config = function ()
                require('mason').setup()
            end
        }
        use {
            'williamboman/mason-lspconfig.nvim',
            config = function ()
                require("mason-lspconfig").setup({
                    ensure_installed = {
                        "sumneko_lua",
                        "bashls",
                        "clangd",
                        "html",
                        "cmake",
                        "dockerls",
                        "jdtls",
                        "jsonls",
                        "marksman",
                        -- "ltex",
                        "pyright",
                        "rust_analyzer",
                        "vimls",
                        "yamlls",
                    },
                    automatic_installation = false,
                })
            end
        }

        -- Status-line and tab-line with needed icons
        use {
            'kyazdani42/nvim-web-devicons',
            config = function() require('nvim-web-devicons').setup() end
        }

        use {
            'nvim-lualine/lualine.nvim',
            event = 'BufEnter',
            config = function()
                require('lualine').setup({
                    options = {
                        theme = 'base16',
                    }
                })
            end
        }

        use {
            'akinsho/bufferline.nvim',
            tag = 'v2.*',
            config = function()
                require('bufferline').setup({
                    options = {
                        right_mouse_command = function() end,
                    }
                })
            end
        }

        -- Themes
        use { 'RRethy/nvim-base16' }
        use { 'EdenEast/nightfox.nvim' }
        use { 'olimorris/onedarkpro.nvim' }
        use { 'tanvirtin/monokai.nvim' }

        -- Dashboard
        use { 'glepnir/dashboard-nvim' }

        -- Syntax highlighting and more stuff, treesitter in weird
        use({
            {
                'nvim-treesitter/nvim-treesitter',
                -- run = ":TSUpdate",
                config = function()
                    require('nvim-treesitter.configs').setup({
                        auto_install = false,
                        ensure_installer = {
                            'lua',
                            'javascript',
                            'markdown',
                            'markdown-inline',
                            'html',
                            'css',
                            'php',
                            'json',
                            'bash',
                            'cpp',
                            'java',
                            'dockerfile',
                            'gitignore',
                            'latex',
                            'python',
                            'yaml',
                            'glsl',
                            'scheme',
                        },
                        highlight = {
                            enable = true,
                            additional_vim_regex_highlighting = false,
                            disable = function(lang, bufnr)
                                    return (vim.api.nvim_buf_line_count(bufnr) > 5000)
                            end
                        },
                        -- refactor = {
                        --     highlight_definitions = { enable = true },
                        --     highlight_current_scope = { enable = false },
                        -- },
                        indent = {
                            enable = true,
                            disable = function(lang, bufnr)
                                    return (vim.api.nvim_buf_line_count(bufnr) > 5000)
                            end
                        },
                    })
                end,
            },
            {
                'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'
            }
        })

        use {
            'norcalli/nvim-colorizer.lua',
            event = 'CursorHold',
            config = function()
                require('colorizer').setup()
            end,
        }

        -- Indentation guides
        use {
            'lukas-reineke/indent-blankline.nvim',
            event = 'BufRead',
            config = function()
                require('indent_blankline').setup({
                    -- space_char_blankline = " ",
                    show_current_context = true,
                    show_current_context_start = true,
                    filetype_exclude = { 'dashboard' }
                })
            end
        }

        -- File explorer
        use {
            'kyazdani42/nvim-tree.lua',
            event = 'CursorHold',
            run = ':TSUpdate',
            config = function()
                require('nvim-tree').setup({
                    update_focused_file = { enable = true },
                    view = {
                        width = 35,
                        side = 'left',
                    },
                    git = { ignore = false },
                    renderer = {
                        icons = {
                            show = {
                                git = true,
                                folder = true,
                                file = true,
                                folder_arrow = false,
                            },
                        },
                        indent_markers = {
                            enable = true,
                        },
                    },
                })
            end,
        }

        -- Telescope: search with preview
        use({
            {
                'nvim-telescope/telescope.nvim',
                event = 'CursorHold',
                config = function()
                    local actions = require('telescope.actions')
                    local telescopeConfig = require("telescope.config")

                    -- Clone the default Telescope configuration
                    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
                    -- I want to search in hidden/dot files.
                    table.insert(vimgrep_arguments, "--hidden")
                    -- I don't want to search in the `.git` directory.
                    table.insert(vimgrep_arguments, "--glob")
                    table.insert(vimgrep_arguments, "!.git/*")

                    require('telescope').setup({
                        defaults = {
                            prompt_prefix = ' ❯ ',
                            initial_mode = 'insert',
                            sorting_strategy = 'ascending',
                            layout_config = {
                                prompt_position = 'top',
                                width = 0.95,
                                preview_width = 0.65,
                            },
                            mappings = {
                                i = {
                                    ['<esc>'] = actions.close,
                                    ['<C-j>'] = actions.move_selection_next,
                                    ['<C-k>'] = actions.move_selection_previous,
                                    ['<A-J>'] = actions.preview_scrolling_down,
                                    ['<A-K>'] = actions.preview_scrolling_up,
                                },
                            },
                        },
                        -- extensions = {
                        --     fzf = {
                        --         fuzzy = true,
                        --         override_generic_sorter = true, -- override the generic sorter
                        --         override_file_sorter = true, -- override the file sorter
                        --         case_mode = 'smart_case', -- "smart_case" | "ignore_case" | "respect_case"
                        --     },
                        -- },
                        pickers = {
                            find_files = {
                                -- hidden = true -- will still show the inside of `.git/`
                                find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
                            }
                        }
                    })
                end,
            },
            {
                'nvim-telescope/telescope-fzf-native.nvim', -- As of now I'm not using it
                after = 'telescope.nvim',
                run = 'make',
                config = function()
                    require('telescope').load_extension('fzf')
                end,
            },
        })

        -- completition plugin
        use {
            'hrsh7th/nvim-cmp',
            -- event = 'InsertEnter',
            config = function()
                require('nvim-cmp')
            end,
        }

        -- LSP completition source
        use { 'hrsh7th/cmp-nvim-lsp' }

        -- Other useful cmp things
        use { 'hrsh7th/cmp-nvim-lua' }
        use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
        use { 'hrsh7th/cmp-path' }
        use { 'hrsh7th/cmp-buffer' }

        use {
            "L3MON4D3/LuaSnip",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        }

        -- LSP, Completition and shit
        use {
            'neovim/nvim-lspconfig',
            event = 'BufRead',
            config = function()
                require('lsp')
            end,
        }

        -- todo and other tags manager
        use {
            "folke/todo-comments.nvim",
            config = function()
                require("todo-comments").setup({})
            end
        }

        -- Markdown previewer
        use({
            "iamcco/markdown-preview.nvim",
            run = function() vim.fn["mkdp#util#install"]() end,
        })

        -- Autosave
        use {
            'Pocco81/auto-save.nvim',
            config = function() require('auto-save').setup() end
        }

        use { 'voldikss/vim-floaterm' }

        -- Comment toggle
        use {
            'terrortylor/nvim-comment',
            config = function()
                require('nvim_comment').setup({
                    comment_empty = false,
                })
            end
        }

        -- Automatically closes brackets
        use {
            'windwp/nvim-autopairs',
            config = function() require('nvim-autopairs').setup() end,
        }
    end,

    -- Display the Packer window in floating mode
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end,
        },
    },
})
