return {
  {
    "shyun3/vim-endwise",
    branch = "personal",
    event = "FileType", -- Must be loaded early for plugin to work properly

    -- Endwise wraps <CR> with its own mapping on startup by default, so make
    -- sure autopairs performs its wrapping first
    dependencies = "windwp/nvim-autopairs",

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

  { "tpope/vim-fugitive", cmd = "Git" },
  "tpope/vim-projectionist",
  "tpope/vim-repeat",

  {
    "tpope/vim-surround",
    event = "ModeChanged",

    init = function()
      -- To allow remapping i_<C-s>
      vim.g.surround_no_insert_mappings = 1
    end,
  },

  { "tpope/vim-unimpaired", event = "BufEnter" },
}
