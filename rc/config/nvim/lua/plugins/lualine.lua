-- Taken from molokai in vim-airline-themes
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

-- Taken from molokai in vim-airline-themes
local theme = {
  normal = {
    a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.white, bg = colors.dark_gray },
    c = { fg = colors.white, bg = colors.gray },
  },
  insert = {
    a = { fg = colors.black, bg = colors.blue, gui = "bold" },
  },
  replace = {
    a = { fg = colors.black, bg = colors.red, gui = "bold" },
  },
  visual = {
    a = { fg = colors.black, bg = colors.green, gui = "bold" },
  },
  command = {
    a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
  },
  inactive = {
    a = { fg = colors.light_black, bg = colors.gray },
    b = { fg = colors.light_black, bg = colors.gray },
    c = { fg = colors.light_black, bg = colors.gray },
  },
}

local filename = {
  "filename",
  newfile_status = true,
  path = 1, -- Relative path
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = {
    options = { theme = theme },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { filename },
      lualine_x = { "filetype" },
      lualine_y = { "encoding", "fileformat" },
      lualine_z = {
        "progress",
        "location",
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "warn" },
          colored = false,

          -- Taken from 'airline_warning'
          color = { bg = "#df5f00" },

          separator = { left = "" },
        },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "error" },
          colored = false,

          -- Taken from 'airline_error'
          color = { bg = "#990000" },

          separator = { left = "" },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
