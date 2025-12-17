-- Taken from https://github.com/ribru17/ts_query_ls#example-setup-for-neovim
return {
  init_options = {
    parser_install_directories = {
      -- If using nvim-treesitter with lazy.nvim
      vim.fs.joinpath(vim.fn.stdpath("data"), "/lazy/nvim-treesitter/parser/"),
    },
  },
}
