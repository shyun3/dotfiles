local components = require("util.lualine")

local filename = {
  "filename",
  newfile_status = true,
  path = 1, -- Relative path

  symbols = {
    readonly = "", -- Taken from airline
  },
}

return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",

  opts = {
    options = {
      theme = "my_catpuccin",
      globalstatus = true,
      refresh = { statusline = 100 },
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "vcs", draw_empty = true }, "diff" },

      lualine_c = {
        filename,
        {
          -- Show @recording messages
          -- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components

          ---@class NoiceStatus
          ---@field get fun(): boolean
          ---@field has fun(): boolean

          function() return require("noice").api.status.mode.get() end,
          cond = function() return require("noice").api.status.mode.has() end,

          -- For some reason, the fg color isn't inherited from the theme if
          -- the gui option is specified unless a function is used
          color = function() return { gui = "bold" } end,
        },
      },
      lualine_x = {
        {
          -- Search count messages
          -- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components

          function() return require("noice").api.status.search.get() end,
          cond = function() return require("noice").api.status.search.has() end,
        },
        {
          "lsp_status",
          symbols = {
            separator = " \u{f013} ", -- Default icon: 
          },
        },
        components.filetype,
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
    extensions = { LazyDep("oil") and "oil", "my_quickfix" },
  },

  config = function(_, opts)
    if LazyDep("oil") then
      local oil = require("lualine.extensions.oil")
      oil.sections = {
        lualine_c = { oil.sections.lualine_a[1] },

        lualine_a = { "mode" },
        lualine_b = { { "vcs", draw_empty = true } },
        lualine_x = { components.filetype },
        lualine_z = { "my_progress", "my_location" },
      }
    end

    require("lualine").setup(opts)
  end,
}
