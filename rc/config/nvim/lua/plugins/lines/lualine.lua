local molokai = require("util.colors").molokai

local colors = {
  dark_fg = molokai.black,
  light_fg = molokai.white,

  dark_bg = molokai.dark_gray,
  gray_bg = molokai.gray,

  normal = molokai.yellow,
  insert = molokai.blue,
  replace = molokai.red,
  select = molokai.green,
}

-- Taken from molokai in vim-airline-themes
local theme = {
  normal = {
    a = { fg = colors.dark_fg, bg = colors.normal, gui = "bold" },
    b = { fg = colors.light_fg, bg = colors.dark_bg },
    c = function()
      return vim.bo.modified and { fg = colors.dark_fg, bg = colors.normal }
        or { fg = colors.light_fg, bg = colors.gray_bg }
    end,
  },
  insert = {
    a = { fg = colors.dark_fg, bg = colors.insert, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.dark_fg, bg = colors.insert }
        or { fg = colors.light_fg, bg = colors.gray_bg }
    end,
  },
  replace = {
    a = { fg = colors.dark_fg, bg = colors.replace, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.dark_fg, bg = colors.replace }
        or { fg = colors.light_fg, bg = colors.gray_bg }
    end,
  },
  visual = {
    a = { fg = colors.dark_fg, bg = colors.select, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.dark_fg, bg = colors.select }
        or { fg = colors.light_fg, bg = colors.gray_bg }
    end,
  },
  command = {
    a = { fg = colors.dark_fg, bg = colors.normal, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.dark_fg, bg = colors.normal }
        or { fg = colors.light_fg, bg = colors.gray_bg }
    end,
  },
}

local filename = {
  "filename",
  newfile_status = true,
  path = 1, -- Relative path

  symbols = {
    readonly = "", -- Taken from airline
  },
}

local filetype = { "filetype", colored = false }

local function progress()
  local prog = require("lualine.components.progress")()
  if prog == "Top" then
    return "0%%"
  elseif prog == "Bot" then
    return "100%%"
  else
    return vim.trim(prog)
  end
end

-- Derived from location component
local function location()
  local line = vim.fn.line(".")
  local col = vim.fn.charcol(".")
  local max_line = vim.fn.line("$")

  -- Symbols taken from airline
  return string.format(":%d/%d≡ ℅:%d", line, max_line, col)
end

return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",

  opts = {
    options = {
      theme = theme,
      globalstatus = true,
      refresh = { statusline = 100 },
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "branch", draw_empty = true }, "diff" },

      ---@class NoiceStatus
      ---@field get fun(): boolean
      ---@field has fun(): boolean

      lualine_c = {
        filename,
        {
          -- Show @recording messages
          -- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components

          function() return require("noice").api.status.mode.get() end,
          cond = function() return require("noice").api.status.mode.has() end,

          color = function()
            -- For some reason, the fg color isn't inherited from the theme if
            -- the gui option is specified
            return {
              fg = vim.bo.modified and colors.dark_fg or colors.light_fg,
              gui = "bold",
            }
          end,
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
            -- Remove spinner and done symbols (covered by noice)
            spinner = {},
            done = "",
          },
        },
        filetype,
      },
      lualine_y = { "encoding", "fileformat" },
      lualine_z = {
        progress,
        location,
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
    extensions = { "oil", "quickfix" },
  },

  config = function(_, opts)
    require("lualine.extensions.quickfix").sections.lualine_z =
      { progress, location }

    local oil = require("lualine.extensions.oil")
    oil.sections = {
      lualine_c = { oil.sections.lualine_a[1] },

      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_x = { filetype },
      lualine_z = { progress, location },
    }

    require("lualine").setup(opts)
  end,
}
