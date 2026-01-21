return {
  {
    LazyDep("nvim-autopairs"),
    optional = true,

    opts = {
      _my_custom_rules = {
        function(rule, conds)
          return {
            rule('"""', '"""', "jjconfig.toml"):with_pair(
              conds.not_before_char('"', 3)
            ),
            rule("'''", "'''", "jjconfig.toml"):with_pair(
              conds.not_before_char("'", 3)
            ),
          }
        end,
      },
    },
  },

  {
    LazyDep("nvim-treesitter-jjconfig"),
    dependencies = LazyDep("lspconfig"),

    event = {
      -- To load before filetype event, otherwise highlighting may not occur
      "BufReadPre",

      -- To install on startup, even if no file was opened
      "VeryLazy",
    },

    opts = { ensure_installed = true },
  },
}
