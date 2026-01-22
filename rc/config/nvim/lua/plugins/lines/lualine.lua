local filename = {
  "filename",
  newfile_status = true,
  path = 1, -- Relative path

  symbols = {
    readonly = "", -- Taken from airline
  },
}

return {
  LazyDep("lualine"),
  event = "UIEnter",

  opts_extend = { "extensions", "sections.lualine_c", "sections.lualine_x" },

  opts = {
    options = {
      theme = "my_catpuccin",
      globalstatus = true,
      refresh = { statusline = 100 },
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "vcs", draw_empty = true }, "diff" },
      lualine_c = { filename },

      lualine_x = {
        {
          "lsp_status",
          symbols = {
            separator = " \u{f013} ", -- Default icon: 
          },
        },
        require("util.lualine").filetype,
      },
      lualine_y = { "encoding", "fileformat" },
      lualine_z = {
        "my_progress",
        "my_location",
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

    extensions = { "my_quickfix" },
  },
}
