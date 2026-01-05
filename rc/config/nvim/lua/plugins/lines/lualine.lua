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
  local max_line = vim.fn.line("$")

  local col = vim.fn.charcol(".")
  local virt_col = vim.fn.virtcol(".")
  local col_str = col .. (col == virt_col and "" or "-" .. virt_col)

  -- Symbols taken from airline
  return string.format(":%d/%d≡ ℅:%s", line, max_line, col_str)
end

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
    extensions = { LazyDep("oil") and "oil", "quickfix" },
  },

  config = function(_, opts)
    require("lualine.extensions.quickfix").sections.lualine_z =
      { progress, location }

    if LazyDep("oil") then
      local oil = require("lualine.extensions.oil")
      oil.sections = {
        lualine_c = { oil.sections.lualine_a[1] },

        lualine_a = { "mode" },
        lualine_b = { { "vcs", draw_empty = true } },
        lualine_x = { filetype },
        lualine_z = { progress, location },
      }
    end

    require("lualine").setup(opts)
  end,
}
