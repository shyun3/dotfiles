return {
  {
    LazyDep("vim-endwise"),
    branch = "personal",
    event = "FileType", -- Must be loaded early for plugin to work properly

    -- Endwise wraps <CR> with its own mapping on startup by default, so make
    -- sure any autopairs plugins perform their mappings first
    dependencies = LazyDep("nvim-autopairs"),

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

  "tpope/vim-projectionist",

  { import = "plugins.tpope.unimpaired" },
}
