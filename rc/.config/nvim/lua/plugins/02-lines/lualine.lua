local filename = {
  "filename",
  newfile_status = true,
  path = 1, -- Relative path

  symbols = {
    readonly = "", -- Taken from airline
  },
}

return {
  {
    LazyDep("vimade"),
    optional = true,

    opts = {
      _my_focus_lost_callbacks = {
        -- When nvim focus is lost, lualine may not refresh before vimade
        -- fades. The nvim display does not seem to update after fade. So,
        -- force a lualine refresh before fade.
        --
        -- Make sure this autocommand is registered before vimade so that the
        -- lualine refresh will occur before fade.
        lualine = {
          desc = "Force lualine refresh",
          callback = function() require("lualine").refresh({ force = true }) end,
        },
      },
    },
  },

  {
    LazyDep("lualine"),
    event = "UIEnter",

    opts_extend = { "extensions" },

    opts = {
      options = {
        theme = "my_catpuccin",
        globalstatus = true,
        refresh = { statusline = 100 },
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "my_vcs", draw_empty = true }, "diff" },
        lualine_c = {
          filename,
          {
            "my_noice_mode",

            -- Must be function, otherwise color isn't dynamically updated
            -- as specified by the theme
            color = function() return { gui = "bold" } end,
          },
        },

        lualine_x = {
          "my_noice_search",
          {
            "lsp_status",
            symbols = {
              separator = " \u{f013} ", -- Default icon: 
            },
          },
          "my_filetype",
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
  },
}
