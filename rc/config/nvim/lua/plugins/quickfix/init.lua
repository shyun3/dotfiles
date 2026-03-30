return {
  {
    LazyDep("bqf"),
    ft = "qf",

    opts = {
      func_map = {
        -- These don't seem to open in the last focused window
        open = "",
        openc = "",
        drop = "",

        -- These mappings close the quickfix list
        split = "<C-x><C-s>",
        vsplit = "<C-x><C-v>",

        fzffilter = "",
      },
    },
  },

  { import = "plugins.quickfix.qfenter" },
}
