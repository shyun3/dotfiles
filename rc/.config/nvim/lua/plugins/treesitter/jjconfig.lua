return {
  {
    LazyDep("nvim-autopairs"),
    optional = true,

    opts = {
      _my_custom_rules = {
        jjconfig = function(autopairs)
          return {
            autopairs
              .rule('"""', '"""', { "jjconfig.toml", "jjui.toml" })
              :with_pair(autopairs.conds.not_before_char('"', 3)),
            autopairs
              .rule("'''", "'''", { "jjconfig.toml", "jjui.toml" })
              :with_pair(autopairs.conds.not_before_char("'", 3)),
          }
        end,
      },
    },
  },

  {
    LazyDep("nvim-treesitter"),
    optional = true,

    dependencies = LazyDep("nvim-treesitter-jjconfig"),

    opts = {
      _my_parsers = {
        jjconfig = true,
        jjrevset = true,
        jjtemplate = true,
        jjui = true,
      },
    },
  },

  {
    LazyDep("nvim-treesitter-jjconfig"),
    branch = "main",

    event = {
      -- To load before filetype event, otherwise highlighting may not occur
      "BufReadPre",

      -- To install on startup, even if no file was opened
      "VeryLazy",

      "User LspEnablePre",
    },

    opts = {},
  },
}
