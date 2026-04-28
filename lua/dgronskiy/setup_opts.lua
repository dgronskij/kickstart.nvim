vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.o.hidden = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.showmatch = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"

vim.o.clipboard = ""
-- clipboard = "unnamedplus"

vim.o.errorbells = false

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.wrap = false

vim.o.swapfile = false
vim.o.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = false

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = false

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"

-- Give more space for displaying messages.
vim.o.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.o.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
-- vim.opt.shortmess:append("c")

vim.o.colorcolumn = "120"
vim.o.shada="!,'10000,<50,s10,h" -- default is shada=!,'100,<50,s10,h



-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- -- Sync clipboard between OS and Neovim.
-- --  Schedule the setting after `UiEnter` because it can increase startup-time.
-- --  Remove this option if you want your OS clipboard to remain independent.
-- --  See `:help 'clipboard'`
-- vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true -- TODO: what check


-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300 -- TODO: check

vim.o.list = true  -- TODO: check
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }  -- TODO: check

vim.o.inccommand = 'split'  -- TODO: check

vim.o.cursorline = true -- TODO: check


-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true  -- TODO: check

vim.cmd([[ set wildmode=longest:full,full ]]) -- https://vi.stackexchange.com/a/11424/7248
vim.cmd([[ set path+=$ARCADIA_ROOT ]])  -- set this in ~/.localrc !
