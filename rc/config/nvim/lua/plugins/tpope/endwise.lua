return {
  {
    LazyDep("blink.cmp"),
    optional = true,

    -- Endwise creates mappings which blink may fallback to
    dependencies = LazyDep("vim-endwise"),
  },

  {
    LazyDep("vim-endwise"),
    branch = "personal",
    event = "FileType", -- Must be loaded early for plugin to work properly

    config = function()
      if require("nvim-treesitter-endwise") then
        local disable_langs = { "bash", "lua", "sh", "vim" }
        for _, lang in ipairs(disable_langs) do
          vim.api.nvim_clear_autocmds({
            group = "endwise",
            event = "FileType",
            pattern = lang,
          })
        end
      end
    end,
  },
}
