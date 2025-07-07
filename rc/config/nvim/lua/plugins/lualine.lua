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
    c = function()
      return vim.bo.modified and { fg = colors.black, bg = colors.yellow }
        or { fg = colors.white, bg = colors.gray }
    end,
  },
  insert = {
    a = { fg = colors.black, bg = colors.blue, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.black, bg = colors.blue }
        or { fg = colors.white, bg = colors.gray }
    end,
  },
  replace = {
    a = { fg = colors.black, bg = colors.red, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.black, bg = colors.red }
        or { fg = colors.white, bg = colors.gray }
    end,
  },
  visual = {
    a = { fg = colors.black, bg = colors.green, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.black, bg = colors.green }
        or { fg = colors.white, bg = colors.gray }
    end,
  },
  command = {
    a = { fg = colors.black, bg = colors.yellow, gui = "bold" },

    c = function()
      return vim.bo.modified and { fg = colors.black, bg = colors.yellow }
        or { fg = colors.white, bg = colors.gray }
    end,
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

  symbols = {
    readonly = "", -- Taken from airline
  },
}

local filetype = {
  "filetype",
  colored = false,
}

-- Derived from progress component
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
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/noice.nvim" },
  event = "UIEnter",

  config = function()
    local quickfix = require("lualine.extensions.quickfix")
    quickfix.sections.lualine_z = { progress, location }

    local oil = require("lualine.extensions.oil")
    oil.sections = {
      lualine_c = { oil.sections.lualine_a[1] },
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_x = { filetype },
      lualine_z = { progress, location },
    }

    require("lualine").setup({
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

            ---@diagnostic disable-next-line: undefined-field
            require("noice").api.status.mode.get,

            ---@diagnostic disable-next-line: undefined-field
            cond = require("noice").api.status.mode.has,

            color = function()
              -- For some reason, the fg color isn't inherited from the theme
              -- if the gui option is specified
              return {
                fg = vim.bo.modified and colors.black or colors.white,
                gui = "bold",
              }
            end,
          },
        },
        lualine_x = {
          {
            "lsp_status",
            symbols = {
              -- Remove spinner and done symbols (covered by fidget.nvim)
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
      extensions = { oil, quickfix },
    })
  end,
}
