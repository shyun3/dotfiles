---@module 'snacks'

return {
  {
    LazyDep("mini.files"),
    optional = true,

    opts = {
      _my_rename_callbacks = {
        -- Taken from rename snack
        snacks = {
          desc = "LSP-integrated file rename",

          callback = function(event)
            Snacks.rename.on_rename_file(event.data.from, event.data.to)
          end,
        },
      },
    },
  },

  {
    LazyDep("oil"),
    optional = true,

    opts = {
      _my_post_actions = {
        -- Taken from rename snack
        snacks = {
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
}
