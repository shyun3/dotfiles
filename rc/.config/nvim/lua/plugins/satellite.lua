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
      winblend = 30,

      handlers = {
        -- Seems to prevent scrollbar from displaying on window enter
        gitsigns = { enable = false },
      },
    },

    config = function(_, opts)
      require("satellite").setup(opts)

      local group = vim.api.nvim_create_augroup("my_satellite", {})
      vim.api.nvim_create_autocmd("FocusLost", {
        group = group,
        desc = "Satellite: Hide scrollbar",
        command = "SatelliteDisable",
      })
      vim.api.nvim_create_autocmd("FocusGained", {
        group = group,
        desc = "Satellite: Show scrollbar",
        command = "SatelliteEnable",
      })
    end,
  },
}
