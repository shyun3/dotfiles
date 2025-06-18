return {
  "vim-airline/vim-airline",

  dependencies = {
    "vim-airline/vim-airline-themes",
    "tpope/vim-fugitive",
    "mhinz/vim-grepper",
    "ludovicchabant/vim-gutentags",
  },

  init = function()
    vim.g.airline_theme = "molokai"
    vim.g.airline_powerline_fonts = 1

    vim.g["airline#extensions#whitespace#enabled"] = 0 -- Whitespace error detection
    vim.g["airline#extensions#tagbar#enabled"] = 0
    vim.g["airline#extensions#searchcount#enabled"] = 0

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
    vim.cmd.highlight("StatusLine cterm=NONE gui=NONE")
    vim.cmd.highlight("StatusLineNC cterm=NONE gui=NONE")
    vim.cmd.highlight("TabLine cterm=NONE gui=NONE")
    vim.cmd.highlight("TabLineFill cterm=NONE gui=NONE")

    local group = vim.api.nvim_create_augroup("my_airline", {})
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "GutentagsUpdated",
      command = "AirlineRefresh",
    })
    vim.api.nvim_create_autocmd(
      "DiagnosticChanged",
      { group = group, command = "AirlineRefresh" }
    )
  end,
}
