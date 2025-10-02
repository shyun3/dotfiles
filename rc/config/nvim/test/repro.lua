-- Minimal init.lua to reproduce any issues. Save as repro.lua and run with
-- nvim -u repro.lua.
--
-- Taken from lazy.nvim bug report template

vim.env.LAZY_STDPATH = ".repro"
load(
  vim.fn.system(
    "curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"
  )
)()

require("lazy.minit").repro({
  spec = {
    -- add any other plugins here
  },
})
