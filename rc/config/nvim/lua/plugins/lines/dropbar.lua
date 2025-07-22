return {
  "Bekaboo/dropbar.nvim",
  event = "BufWinEnter",

  opts = {
    icons = {
      ui = {
        bar = {
          separator = " › ", -- Taken from lspsaga
        },
      },
    },

    sources = {
      path = { max_depth = 1 },
    },
  },

  keys = {
    {
      "[;",
      function() require("dropbar.api").goto_context_start() end,
      desc = "Go to start of current context",
    },
  },
}
