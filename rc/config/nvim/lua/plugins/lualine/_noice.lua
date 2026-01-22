return {
  LazyDep("lualine"),
  optional = true,

  opts = {
    sections = {
      lualine_x = {
        {
          -- Search count messages
          -- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#-statusline-components
          function() return require("noice").api.status.search.get() end,
          cond = function() return require("noice").api.status.search.has() end,
        },
      },
    },
  },
}
