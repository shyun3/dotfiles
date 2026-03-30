return {
  {
    LazyDep("snacks"),
    optional = true,

    opts = {
      bigfile = { enabled = true },
    },
  },

  {
    LazyDep("bqf"),
    optional = true,

    opts = {
      preview = {
        should_preview_cb = function(bufnr)
          return vim.bo[bufnr].filetype ~= "bigfile"
        end,
      },
    },
  },
}
