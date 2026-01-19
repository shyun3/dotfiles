return {
  {
    "sheerun/vim-polyglot",
    event = "FileType",

    init = function()
      vim.g.polyglot_disabled = {
        "autoindent", -- Can lead to slow buffer enter
        "ftdetect", -- Use filetype.lua
        "sensible", -- Do not update vim settings

        "python-indent", -- Wrong indent in certain cases
      }

      -- vim-markdown
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_new_list_item_indent = 0
      vim.g.vim_markdown_no_default_key_mappings = 1
    end,

    config = function()
      -- polyglot sets this variable, which prevents loading of `filetype.lua`
      vim.g.did_load_filetypes = nil
    end,
  },

  { "shyun3/vim-antidote", ft = "antidote" },

  {
    "shyun3/vim-ctags-mtable",
    branch = "personal",

    init = function()
      -- Full color highlighting of regexes
      vim.g.ctags_syntax_show_regexp = true
    end,

    ft = "ctags",
  },

  { import = "plugins.syntax.4dgl" },
}
