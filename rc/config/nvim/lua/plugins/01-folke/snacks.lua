---@module 'snacks'

return {
  {
    LazyDep("mini.files"),
    optional = true,

    opts = {
      _my_event_callbacks = {
        MiniFilesActionRename = {
          -- Taken from rename snack
          {
            desc = "LSP-integrated file rename",

            callback = function(event)
              Snacks.rename.on_rename_file(event.data.from, event.data.to)
            end,
          },
        },
      },
    },
  },

  {
    LazyDep("oil"),
    optional = true,

    opts = {
      _my_event_callbacks = {
        OilActionsPost = {
          -- Taken from rename snack
          {
            desc = "LSP-integrated file rename",

            callback = function(event)
              local action = event.data.actions[1]
              if not action then return end

              if action.type == "move" then
                Snacks.rename.on_rename_file(action.src_url, action.dest_url)
              end
            end,
          },
        },
      },
    },
  },

  {
    LazyDep("snacks"),

    opts = {
      lazygit = {
        win = {
          style = "lazygit",

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
