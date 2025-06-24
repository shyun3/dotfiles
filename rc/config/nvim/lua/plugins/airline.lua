return {
  "vim-airline/vim-airline",
  dependencies = { "vim-airline/vim-airline-themes" },

  init = function()
    vim.g.airline_theme = "molokai"
    vim.g.airline_powerline_fonts = 1

    -- Only using this for tabline
    vim.g.airline_disable_statusline = 1

    vim.g["airline#extensions#tabline#enabled"] = 1
    vim.g["airline#extensions#tabline#formatter"] = "uniq_tail_or_proj"
    vim.g["airline#extensions#tabline#fnamemod"] = ":t" -- Default tab name formatter
    vim.g["airline#extensions#tabline#fnamecollapse"] = 0 -- Short parent names in tabs
    vim.g["airline#extensions#tabline#tab_nr_type"] = 1
    vim.g["airline#extensions#tabline#show_close_button"] = 0
    vim.g["airline#extensions#tabline#show_splits"] = 0
    vim.g["airline#extensions#tabline#show_buffers"] = 0
    vim.g["airline#extensions#tabline#show_tab_type"] = 0
  end,

  config = function()
    -- Work around nvim 0.11 statusline changes, see neovim PR #29976
    -- Derived from https://github.com/vim-airline/vim-airline/issues/2693#issuecomment-2424151997
    vim.cmd.highlight("TabLine cterm=NONE gui=NONE")
    vim.cmd.highlight("TabLineFill cterm=NONE gui=NONE")
  end,
}
