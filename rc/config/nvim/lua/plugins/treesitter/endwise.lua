return {
  {
    LazyDep("vim-endwise"),
    optional = true,

    opts = {
      _my_disable_filetypes = { "bash", "lua", "sh", "vim" },
    },
  },

  { "RRethy/nvim-treesitter-endwise", event = "FileType" },
}
