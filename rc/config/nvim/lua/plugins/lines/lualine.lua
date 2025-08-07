-- Taken from molokai in vim-airline-themes
local theme = function()
  local colors = require("lualine.themes.catppuccin")

  --- Create a lualine c section colorscheme whose background lights up with
  --- the mode color if buffer is modified
  ---
  --- @param mode string Mode name used by lualine theme
  --- @return fun(): {fg: string|number, bg: string|number} colorscheme
  local function make_c_section(mode)
    return function()
      return vim.bo.modified
          and { fg = colors[mode].a.fg, bg = colors[mode].a.bg }
        or colors.normal.c
    end
  end

  local modes =
    { "normal", "insert", "replace", "visual", "command", "terminal" }
  local override = {}
  for _, mode in pairs(modes) do
    override[mode] = { c = make_c_section(mode) }
  end

  return vim.tbl_deep_extend("force", colors, override)
end

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
