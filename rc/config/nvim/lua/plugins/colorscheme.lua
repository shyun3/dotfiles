return {
  -- the colorscheme should be available when starting Neovim
  "shyun3/molokai",
  branch = "personal",

  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins

  config = function()
    -- load the colorscheme here
    vim.cmd([[colorscheme molokai]])

    -- See `:h treesitter-highlight-groups`
    vim.api.nvim_set_hl(0, "@variable", { fg = "fg" })
    vim.cmd.highlight("link @variable.parameter NONE")

    -- See `:h lsp-semantic-highlight`
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "fg" })
    vim.cmd.highlight("link @lsp.type.parameter NONE")

    -- Work around nvim 0.11 statusline changes, see neovim PR #29976
    -- Derived from https://github.com/vim-airline/vim-airline/issues/2693#issuecomment-2424151997
    vim.cmd.highlight("TabLine cterm=NONE gui=NONE")
    vim.cmd.highlight("TabLineFill cterm=NONE gui=NONE")
  end,
}
