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

    opts_extend = { "_my_disable_filetypes" },

    config = function(_, opts)
      if opts._my_disable_filetypes then
        for _, ft in ipairs(opts._my_disable_filetypes) do
          vim.api.nvim_clear_autocmds({
            group = "endwise",
            event = "FileType",
            pattern = ft,
          })
        end
      end
    end,
  },
}
