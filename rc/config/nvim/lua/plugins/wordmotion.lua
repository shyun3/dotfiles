return {
  {
    require("lazy-deps").which_key,
    optional = true,

    opts = {
      spec = {
        { "i<Leader>", mode = { "o", "x" }, desc = "Leader" },
        { "a<Leader>", mode = { "o", "x" }, desc = "Leader" },
      },
    },
  },

  {
    "chaoren/vim-wordmotion",

    init = function() vim.g.wordmotion_nomap = 1 end,

    keys = {
      {
        "<Leader>w",
        "<Plug>WordMotion_w",
        mode = { "n", "x", "o" },
        desc = "Next subword",
      },
      {
        "<Leader>e",
        "<Plug>WordMotion_e",
        mode = { "n", "x", "o" },
        desc = "Next end of subword",
      },
      {
        "<Leader>b",
        "<Plug>WordMotion_b",
        mode = { "n", "x", "o" },
        desc = "Previous subword",
      },
      {
        "<Leader>ge",
        "<Plug>WordMotion_ge",
        mode = { "n", "x", "o" },
        desc = "Previous end of subword",
      },

      {
        "i<Leader>w",
        "<Plug>WordMotion_iw",
        mode = { "o", "x" },
        desc = "Subword",
      },
      {
        "a<Leader>w",
        "<Plug>WordMotion_aw",
        mode = { "o", "x" },
        desc = "Subword",
      },
    },
  },
}
