-- Search
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- UI
vim.opt.number = true
vim.opt.wildmode = "longest,list"
vim.opt.cc = "80"
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- System
vim.opt.clipboard = "unnamedplus"
vim.opt.spell = true
vim.opt.undofile = true
vim.opt.autoread = true
vim.opt.updatetime = 300

vim.cmd('filetype plugin on')
vim.cmd('filetype plugin indent on')
