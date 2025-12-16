return {
  {
    "nvim-mini/mini.pairs",
    version = false,

    -- Only being used in command-line mode
    event = "CmdlineEnter",

    opts = {
      modes = {
        insert = LazyDep("nvim-autopairs") and false,
        command = true,
      },

      mappings = {
        ["'"] = {
          neigh_pattern = "[^\\].", -- Allow auto-pairing after letter
        },
      },
    },
  },

  { import = "plugins.mini.ai" },
  { import = "plugins.mini.files" },
}
