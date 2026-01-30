return {
  {
    LazyDep("nvim-autopairs"),
    optional = true,

    opts = {
      _my_custom_rules = {
        function(autopairs)
          return {
            autopairs
              .rule('"""', '"""', "jjconfig.toml")
              :with_pair(autopairs.conds.not_before_char('"', 3)),
            autopairs
              .rule("'''", "'''", "jjconfig.toml")
              :with_pair(autopairs.conds.not_before_char("'", 3)),
          }
        end,
      },
    },
  },

  {
    "acarapetis/nvim-treesitter-jjconfig",

    event = {
      -- To load before filetype event, otherwise highlighting may not occur
      "BufReadPre",

      -- To install on startup, even if no file was opened
      "VeryLazy",

      "User LspEnablePre",
    },

    opts = { ensure_installed = true },
  },
}
