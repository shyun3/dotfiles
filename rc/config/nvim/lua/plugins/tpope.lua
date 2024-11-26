return {
  {
    "shyun3/vim-endwise",
    branch = "personal",

    init = function()
      -- To disable <CR> from being mapped
      vim.g.endwise_no_mappings = 1
    end,

    config = function()
      -- Disable filetypes handled by treesitter
      local disable_langs = { "bash", "lua", "sh", "vim" }
      for _, lang in pairs(disable_langs) do
        vim.api.nvim_clear_autocmds({
          group = "endwise",
          event = "FileType",
          pattern = lang,
        })
      end
    end,
  },

  "tpope/vim-fugitive",
  "tpope/vim-projectionist",
  "tpope/vim-repeat",

  {
    "tpope/vim-surround",
    init = function()
      -- Mainly so that <C-s> can be used to show signature
      vim.g.surround_no_insert_mappings = 1
    end,
  },

  "tpope/vim-unimpaired",
  "tpope/vim-vinegar",
}
