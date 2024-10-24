-- C indent options
vim.o.cinoptions = "g0" -- Don't indent class scope declarations
  .. "N-s" -- Don't indent namespaces
  .. "E-s" -- Don't indent extern blocks

-- Casing
vim.o.ignorecase = true
vim.o.smartcase = true

-- Completions
vim.o.completeopt = "menu,menuone,noinsert"
vim.o.pumheight = 10
vim.opt.wildmode = { "longest:full", "full" }

-- Display
vim.o.number = true -- Line numbers
vim.o.colorcolumn = tostring(require("util").column_limit)
vim.opt.listchars =
  { tab = "» ", trail = "·", precedes = "◄", extends = "►" }
vim.o.list = true -- Show invisible characters
vim.o.cursorline = true
vim.o.cmdheight = 2
vim.opt.shortmess:append("c") -- Don't give completion menu messages
vim.o.signcolumn = "number" -- Replace line number with diagnostic mark
vim.o.showmode = false -- Mode is in status line

-- File settings
vim.o.autowriteall = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.writebackup = false
vim.opt.shada = {
  "'1000", -- Max number of previously edited files whose marks are remembered
  "s1", -- Max size of item contents in kB
  "h", -- Disable 'hlsearch' effect when loading shada file
}

-- Formatting
vim.o.wrap = false
vim.opt.formatoptions:append({ r = true, o = true }) -- Auto comment leaders

-- Search
vim.o.maxmempattern = 5000

-- Tabs
vim.o.expandtab = true -- Change tabs to spaces
vim.o.tabstop = 4
vim.o.softtabstop = vim.o.tabstop -- Tab stop positions for spaces
vim.o.shiftwidth = vim.o.tabstop

-- Timing
vim.o.updatetime = 300

-- Windows
vim.o.splitright = true
vim.o.splitbelow = true
