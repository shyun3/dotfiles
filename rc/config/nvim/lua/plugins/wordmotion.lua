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
