return {
  {
    "tpope/vim-endwise",
    init = function()
      -- To disable <CR> from being mapped
      vim.g.endwise_no_mappings = 1
    end,
  },

  "tpope/vim-fugitive",
  "tpope/vim-projectionist",
  "tpope/vim-repeat",

  {
    "tpope/vim-surround",
    init = function()
      -- Mainly so that <C-s> can be used to show signature
      vim.g.surround_no_insert_mappings = 1
    end,
  },

  "tpope/vim-unimpaired",
  "tpope/vim-vinegar",
}
