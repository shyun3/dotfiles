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

      -- Also applies to lazygit
      terminal = {
        win = {
          wo = {
            -- winbar is added by default when terminal is opened in split
            winbar = "",
          },

          -- Default close action seems to be run from a non-nested
          -- autocommand. So, fire WinEnter when entering previous window.
          on_close = function(win)
            vim.cmd.wincmd("p")
            if vim.api.nvim_get_current_win() ~= win.win then
              vim.cmd.doautocmd("WinEnter")
            end
          end,
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

      {
        "<Leader>t",
        function() Snacks.terminal() end,
        desc = "Open terminal",
      },
      {
        "<Leader>j",

        function()
          local opts = {
            win = {
              border = "rounded",

              keys = {
                -- Disable <Esc> twice quickly to enter normal mode
                term_normal = false,
              },
            },
          }
          Snacks.terminal("jjui", opts)
        end,

        desc = "Open jjui",
      },
    },
  },
}
