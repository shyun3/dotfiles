return {
  {
    LazyDep("blink.cmp"),
    optional = true,

    -- Endwise creates mappings which blink may fallback to
    dependencies = LazyDep("vim-endwise"),
  },

  {
    LazyDep("vim-endwise"),
    event = "FileType", -- Must be loaded early for plugin to work properly

    opts_extend = { "_my_disable_filetypes" },

    opts = {
      _my_filetypes = {
        meson = {
          addition = [[\="end" . submatch(0)]],
          words = "if,foreach",
          pattern = [[\v<%(if|foreach)>]],
          syngroups = "mesonConditional,mesonRepeat",
        },
      },
    },

    config = function(_, opts)
      for ft, settings in pairs(opts._my_filetypes or {}) do
        vim.api.nvim_create_autocmd("FileType", {
          group = "endwise",
          pattern = ft,
          desc = "vim-endwise settings",

          callback = function(args)
            local bufnr = args.buf
            vim.b[bufnr].endwise_addition = settings.addition
            vim.b[bufnr].endwise_words = settings.words
            vim.b[bufnr].endwise_pattern = settings.pattern
            vim.b[bufnr].endwise_syngroups = settings.syngroups
          end,
        })
      end

      for _, ft in ipairs(opts._my_disable_filetypes or {}) do
        vim.api.nvim_clear_autocmds({
          group = "endwise",
          event = "FileType",
          pattern = ft,
        })
      end
    end,
  },
}
