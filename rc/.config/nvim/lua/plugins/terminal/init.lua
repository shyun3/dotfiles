return {
  {
    LazyDep("flatten"),

    -- Ensure this runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 2000,

    opts = {
      block_for = { jjdescription = true },
      window = { open = "tab" },

      hooks = {
        guest_data = function()
          return {} -- To allow hooks to add data and pass them along
        end,
      },
    },
  },

  { import = "plugins.terminal.toggleterm" },
}
