return {
  LazyDep("lualine"),
  optional = true,

  opts = {
    sections = {
      lualine_c = {
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
    },
  },
}
