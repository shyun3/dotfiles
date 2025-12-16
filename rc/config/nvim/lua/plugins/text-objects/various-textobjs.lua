return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        { "i<Leader>", mode = { "o", "x" }, desc = "Leader" },
        { "a<Leader>", mode = { "o", "x" }, desc = "Leader" },
      },
    },
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    event = "ModeChanged",

    opts = {
      keymaps = { useDefaults = false },
    },

    keys = {
      -- For dot-repeat to work, motions must be called as Ex commands
      {
        "i<Leader>w",
        "<Cmd>lua require('various-textobjs').subword('inner')<CR>",
        mode = { "o", "x" },
        desc = "Subword",
      },
      {
        "a<Leader>w",
        "<Cmd>lua require('various-textobjs').subword('outer')<CR>",
        mode = { "o", "x" },
        desc = "Subword",
      },
    },
  },
}
