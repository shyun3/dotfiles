return {
  {
    require("lazy-deps").endwise,
    branch = "personal",
    event = "FileType", -- Must be loaded early for plugin to work properly

    -- Endwise wraps <CR> with its own mapping on startup by default, so make
    -- sure any autopairs plugins perform their mappings first
    dependencies = require("lazy-deps").autopairs,

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

  { "tpope/vim-unimpaired", event = "VeryLazy" },
}
