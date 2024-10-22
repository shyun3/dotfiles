return {
  {
    "preservim/nerdtree",
    init = function() vim.g.NERDTreeHijackNetrw = 0 end,

    keys = {
      { "<C-n>", "<Cmd>NERDTreeFocus<CR>" },
      { "<A-n>", "<Cmd>NERDTreeFind<CR>" },
      { "<Leader>n", "<Cmd>NERDTree<CR>" },
    },
  },

  {
    "tiagofumo/vim-nerdtree-syntax-highlight",
    dependencies = { "ryanoasis/vim-devicons", "preservim/nerdtree" },

    init = function()
      vim.g.WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1
    end,

    ft = "nerdtree",
  },
}
