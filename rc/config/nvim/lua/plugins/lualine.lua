-- Derived from molokai in vim-airline-themes
local colors = {
  black = "#080808",
  yellow = "#e6db74",
  white = "#f8f8f0",
  dark_gray = "#232526",
  gray = "#465457",
  blue = "#66d9ef",
  red = "#f92672",
  green = "#a6e22e",
  light_black = "#1b1d1e",
}

local theme = {
  normal = {
    a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.white, bg = colors.dark_gray },
    c = { fg = colors.white, bg = colors.gray },
  },
  insert = {
    a = { fg = colors.black, bg = colors.blue, gui = "bold" },
    b = { fg = colors.white, bg = colors.dark_gray },
    c = { fg = colors.white, bg = colors.gray },
  },
  replace = {
    a = { fg = colors.black, bg = colors.red, gui = "bold" },
    b = { fg = colors.white, bg = colors.dark_gray },
    c = { fg = colors.white, bg = colors.gray },
  },
  visual = {
    a = { fg = colors.black, bg = colors.green, gui = "bold" },
    b = { fg = colors.white, bg = colors.dark_gray },
    c = { fg = colors.white, bg = colors.gray },
  },
  command = {
    a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.white, bg = colors.dark_gray },
    c = { fg = colors.white, bg = colors.gray },
  },
  inactive = {
    a = { fg = colors.light_black, bg = colors.gray },
    b = { fg = colors.light_black, bg = colors.gray },
    c = { fg = colors.light_black, bg = colors.gray },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = {
    options = { theme = theme },
  },
}
