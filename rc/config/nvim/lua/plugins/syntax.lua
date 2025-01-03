return {
  {
    "sheerun/vim-polyglot",

    init = function()
      -- autoindent: Can lead to slow buffer enter
      -- ftdetect: Use filetype.lua
      -- lua: Covered by treesitter
      -- sensible: Do not update vim settings
      vim.g.polyglot_disabled = { "autoindent", "ftdetect", "lua", "sensible" }
    end,

    config = function()
      -- polyglot sets this variable, which prevents loading of `filetype.lua`
      vim.g.did_load_filetypes = nil

      ------------------------------------------------------------------------
      -- vim-cpp-modern
      vim.cmd.highlight("link cppSTLios NONE") -- STL I/O manipulators
      vim.cmd.highlight("link cppSTLconstant NONE") -- C++17 constants
      vim.cmd.highlight("link cppSTLtype NONE") -- C++17 STL types
      vim.cmd.highlight("link cppSTLconcept NONE") -- C++20 concepts

      ------------------------------------------------------------------------
      -- vim-markdown
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_new_list_item_indent = 0

      -- Disable `gx` mapping
      vim.keymap.set("", "<Plug>", "<Plug>Markdown_OpenUrlUnderCursor")
    end,
  },

  { "shyun3/vim-4dgl", ft = "4dgl" },
}
