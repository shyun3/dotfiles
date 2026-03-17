return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        {
          "<LeftMouse>",
          mode = { "n", "v", "o", "i" },
          desc = "Satellite: Drag scrollbar",
        },
      },
    },
  },

  {
    "lewis6991/satellite.nvim",
    event = "BufWinEnter",

    opts = {
      current_only = true,

      handlers = {
        -- Seems to prevent scrollbar from displaying on window enter
        gitsigns = { enable = false },
      },
    },
  },
}
