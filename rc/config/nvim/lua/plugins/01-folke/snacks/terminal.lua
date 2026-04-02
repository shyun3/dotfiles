---@module 'snacks'

return {
  {
    LazyDep("snacks"),
    optional = true,

    opts = {
      -- Also applies to lazygit
      terminal = {
        win = {
          wo = {
            -- winbar is added by default when terminal is opened in split
            winbar = "",
          },

          -- Default close action seems to be run from a non-nesting
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

  {
    LazyDep("flatten"),
    optional = true,

    opts = {
      -- Derived from https://github.com/willothy/flatten.nvim#toggleterm
      hooks = {
        pre_open = function(ctx)
          local win_id = vim.api.nvim_get_current_win()
          for _, win in ipairs(Snacks.terminal.list()) do
            if win.win == win_id then
              ctx.data.term_win = win
              break
            end
          end
        end,

        post_open = function(ctx)
          local term_win = ctx.data.term_win
          if ctx.is_blocking and term_win and term_win:is_floating() then
            term_win:hide()
          end
        end,

        block_end = function(ctx)
          local term_win = ctx.data.term_win
          if term_win then
            -- Using schedule, otherwise may get error about terminal being
            -- closed
            vim.schedule(function() term_win:show() end)
          end
        end,
      },
    },
  },
}
