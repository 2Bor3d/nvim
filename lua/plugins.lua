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
                ensure_installed = { "lua", "python", "javascript", "typescript", "vim", "vimdoc" },
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
                ensure_installed = { "lua_ls", "pyright", "ts_ls" },
                automatic_enable = true,
            })

            -- In Neovim 0.11+, we can set default capabilities globally
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", {
                capabilities = capabilities,
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
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

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
                    adapter = "ollama",
                    model = "gemma4:26b"
                },
                inline = {
                    adapter = "ollama",
                    model = "gemma4:e4b",
                },
            },
        },
    },
}

