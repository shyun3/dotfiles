local molokai = require("util.colors").molokai

local colors = {
  dark_fg = molokai.black,
  light_fg = molokai.white,
  inactive_fg = molokai.light_black,

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
  inactive = {
    a = { fg = colors.inactive_fg, bg = colors.gray_bg },
    b = { fg = colors.inactive_fg, bg = colors.gray_bg },
    c = { fg = colors.inactive_fg, bg = colors.gray_bg },
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

local filetype = {
  "filetype",
  colored = false,
}

-- Same as progress component, except 0% and 100% are shown instead of "Top"
-- and "Bot"
local function progress()
  local curr = vim.fn.line(".")
  local total = vim.fn.line("$")

  local percent
  if curr == 1 then
    percent = 0
  elseif curr == total then
    percent = 100
  else
    percent = curr / total * 100
  end

  return string.format("%d%%%%", math.floor(percent))
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
  dependencies = "nvim-tree/nvim-web-devicons",
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
      lualine_c = {
        filename,
        {
          -- Show @recording messages
          -- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components

          function()
            ---@diagnostic disable-next-line: undefined-field
            return require("noice").api.status.mode.get()
          end,

          cond = function()
            ---@diagnostic disable-next-line: undefined-field
            return require("noice").api.status.mode.has()
          end,

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

          function()
            ---@diagnostic disable-next-line: undefined-field
            return require("noice").api.status.search.get()
          end,

          cond = function()
            ---@diagnostic disable-next-line: undefined-field
            return require("noice").api.status.search.has()
          end,
        },
        {
          "lsp_status",
          symbols = {
            -- Remove spinner and done symbols (covered by noice)
            spinner = {},
            done = "",

            separator = " ",
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
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = { filetype, location },
      lualine_y = {},
      lualine_z = {},
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
