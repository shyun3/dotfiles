return {
  {
    LazyDep("vim-endwise"),
    optional = true,

    -- Endwise wraps <CR> with its own mapping on startup by default, so make
    -- sure any autopairs plugins perform their mappings first
    dependencies = LazyDep("nvim-autopairs"),
  },

  {
    LazyDep("nvim-autopairs"),
    event = "InsertEnter",

    opts = {},
  },
}
