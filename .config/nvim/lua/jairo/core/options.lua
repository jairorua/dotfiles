vim.g.netrw_liststyle = 3 -- Use vim tree style in nvim

-- Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabs & Indentation
vim.opt.tabstop = 4 -- spaces for tabs
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.smartindent = true

vim.opt.wrap = false

-- Back-ups and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search setting
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if mixed case included, becomes case-sensitive
-- vim.opt.hlsearch = false -- do not highligh searches
vim.opt.incsearch = true

-- Gui colors
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes become automatically dark if available
vim.opt.signcolumn = "yes" -- show sign column so taht text does not shift

-- Scrolloff
vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

-- Backspace
vim.opt.backspace = "indent,eol,start" -- behave as intended

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- system clipboard as default register

-- Update time
vim.opt.updatetime = 50

-- Colorcolumn
vim.opt.colorcolumn = "80,120"
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "Grey", bg = "Grey" })

-- Windows split
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom
