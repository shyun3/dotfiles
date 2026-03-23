return {
  {
    LazyDep("vim-endwise"),
    optional = true,

    opts = {
      _my_disable_filetypes = {
        bash = true,
        lua = true,
        sh = true,
        vim = true,
      },
    },
  },

  { "RRethy/nvim-treesitter-endwise", event = "FileType" },
}
