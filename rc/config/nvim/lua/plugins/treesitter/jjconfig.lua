return {
  LazyDep("nvim-treesitter-jjconfig"),
  dependencies = LazyDep("lspconfig"),

  event = {
    -- To load before filetype event, otherwise highlighting may not occur
    "BufReadPre",

    -- To install on startup, even if no file was opened
    "VeryLazy",
  },

  opts = { ensure_installed = true },

  config = function(_, opts)
    require("nvim-treesitter-jjconfig").setup(opts)

    -- LSP semantic highlighting of strings may take priority, so disable
    vim.cmd.highlight("link @lsp.type.string.jjconfig.toml NONE")

    local rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    require("nvim-autopairs").add_rules({
      rule('"""', '"""', "jjconfig.toml"):with_pair(
        cond.not_before_char('"', 3)
      ),
      rule("'''", "'''", "jjconfig.toml"):with_pair(
        cond.not_before_char("'", 3)
      ),
    })
  end,
}
