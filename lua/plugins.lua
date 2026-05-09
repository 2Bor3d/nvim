return {
    -- Theme
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "tokyonight-night"
            vim.cmd.hi "Comment gui=none"
        end,
    },
    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "tokyonight",
                section_separators = "",
                component_separators = "",
            },
        },
    },
    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    -- Git integration
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
    },
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "lua",
                    "python",
                    "javascript",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "vue",
                    "css",
                    "html",
                    "latex",
                    "bibtex",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    -- LSP & Mason
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ts_ls",
                    "volar",
                    "tailwindcss",
                    "eslint",
                    "texlab",
                },
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- In Neovim 0.11+, we can set default capabilities globally
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})

            -- Configure Volar
            lspconfig.volar.setup({})

            -- Configure ts_ls with Hybrid Mode for Vue
            lspconfig.ts_ls.setup({
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = require("mason-registry").get_package("vue-language-server"):get_install_path()
                                .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
                            languages = { "javascript", "typescript", "vue" },
                        },
                    },
                },
                filetypes = { "javascript", "typescript", "vue" },
            })

            -- Tailwind CSS support
            lspconfig.tailwindcss.setup({})

            -- Configure LaTex
            lspconfig.texlab.setup({})

            -- Diagnostic configuration
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Diagnostic keymaps
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

            -- Show diagnostics under the cursor when holding position
            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                    local opts = {
                        focusable = false,
                        close_events = { "CursorMoved", "CursorMovedI", "BufLeave" },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'cursor',
                    }
                    vim.diagnostic.open_float(nil, opts)
                end
            })
        end,
    },
    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "micangl/cmp-vimtex",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            luasnip.add_snippets("tex", {
                luasnip.snippet("!", {
                    luasnip.text_node({ "\\documentclass{article}", "", "\\title{" }),
                    luasnip.insert_node(1),
                    luasnip.text_node({ "}", "\\date{" }),
                    luasnip.insert_node(2),
                    luasnip.text_node({ "}", "", "\\begin{document}", "    \\maketitle", "", "" }),
                    luasnip.insert_node(0),
                    luasnip.text_node({ "", "\\end{document}" }),
                }),
            })

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
    -- AI Assistant
    {
        "olimorris/codecompanion.nvim",
        version = "^19.0.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            adapters = {
                gemini_cli = function()
                    return require("codecompanion.adapters").extend("gemini_cli", {
                        defaults = {
                            auth_method = "oauth-personal",
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = "gemini_cli",
                },
                inline = {
                    adapter = "ollama",
                    model = "gemma4:e4b",
                },
            },
        },
    },
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                vue = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
        },
    },
    -- Nuxt utilities
    {
        "rushjs1/nuxt-goto.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {},
    },
    -- LaTex
    {
        "let-def/texpresso.vim",
    },
    {
        "lervag/vimtex",
        lazy = false,
    }
}
