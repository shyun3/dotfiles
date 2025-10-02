return {
  {
    "nvim-mini/mini.pairs",
    version = false,
    event = "CmdlineEnter",

    opts = {
      modes = {
        insert = false, -- Handled by nvim-autopairs
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
