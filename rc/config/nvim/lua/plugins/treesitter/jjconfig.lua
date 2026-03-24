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
    "acarapetis/nvim-treesitter-jjconfig",
    branch = "main",
    build = ":TSUpdate",

    event = {
      -- To load before filetype event, otherwise highlighting may not occur
      "BufReadPre",

      -- To install on startup, even if no file was opened
      "VeryLazy",

      "User LspEnablePre",
    },

    config = function()
      require("nvim-treesitter-jjconfig").setup()

      require("nvim-treesitter").install({
        "jjconfig",
        "jjrevset",
        "jjtemplate",
        "jjui",
      })
    end,
  },
}
