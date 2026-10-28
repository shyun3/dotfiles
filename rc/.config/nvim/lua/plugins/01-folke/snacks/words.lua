---@module 'snacks'

return {
  LazyDep("snacks"),
  optional = true,

  opts = {
    words = {
      enabled = true,
      modes = {
        "n",
        "c", -- Needed for jump to work when called from Ex command
      },
    },
  },

  keys = {
    {
      "<A-8>",
      function() Snacks.words.jump(vim.v.count1, true) end,
      desc = "Jump to next LSP reference",
    },
    {
      "<A-3>",
      function() Snacks.words.jump(-vim.v.count1, true) end,
      desc = "Jump to previous LSP reference",
    },
  },
}
