return {
  {
    "shyun3/vim-ctags-mtable",
    branch = "personal",

    init = function()
      -- Full color highlighting of regexes
      vim.g.ctags_syntax_show_regexp = true
    end,

    ft = "ctags",
  },

  {
    "ludovicchabant/vim-gutentags",
    event = "VeryLazy",

    init = function()
      vim.g.gutentags_define_advanced_commands = 1

      vim.g.gutentags_project_root = { ".gutctags" }
      vim.g.gutentags_add_default_project_roots = 0
      vim.g.gutentags_add_ctrlp_root_markers = 0

      vim.g.gutentags_ctags_tagfile = ".gutentags"

      vim.filetype.add({
        filename = {
          [".gutctags"] = "ctags",
          [".gutentags"] = "tags",
        },
      })
    end,
  },
}
