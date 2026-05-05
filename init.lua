vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = "longest,list"
vim.opt.cc = "80"
vim.opt.syntax = "on"
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.ttyfast = true
vim.opt.spell = true
vim.opt.scrolloff = 10
vim.opt.undofile = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.cmd('filetype plugin on')
vim.cmd('filetype plugin indent on')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- your plugins go here
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "tsserver",
                },
            })

            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup_handlers({
                function(server)
                    lspconfig[server].setup({})
                end,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        init = function()
            vim.cmd.colorscheme "tokyonight-night"
            vim.cmd.hi "Comment gui=none"
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        version = "^19.0.0",
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
})

