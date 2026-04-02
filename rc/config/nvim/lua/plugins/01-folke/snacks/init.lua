---@module 'snacks'

return {
  {
    LazyDep("snacks"),

    -- See `:checkhealth snacks`
    lazy = false, -- Should not be lazy loaded
    priority = 1000, -- Should have priority of 1000 or higher

    opts = {
      lazygit = {
        win = {
          -- Disable <Esc> twice quickly to enter normal mode
          -- Derived from https://github.com/folke/snacks.nvim/issues/280#issuecomment-2987923844
          keys = { term_normal = false },
        },
      },
    },

    keys = {
      {
        "<Leader>lg",
        function() Snacks.lazygit() end,
        desc = "Open lazygit",
      },
      {
        "<Leader>lf",
        function() Snacks.lazygit.log_file() end,
        desc = "lazygit: Open log of current file",
      },
    },
  },
}
