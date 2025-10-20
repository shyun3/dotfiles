return {
  {
    "nvim-mini/mini.pairs",
    version = false,

    -- Only being used in command-line mode
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

  {
    "nvim-mini/mini.surround",
    version = false,

    -- So that which-key will properly list surround group at startup
    event = "VeryLazy",

    opts = { respect_selection_type = true },

    keys = {
      -- Otherwise, which-key does not pop up when hitting this prefix
      { "s", function() require("which-key").show("s") end, desc = "Surround" },
    },
  },

  { import = "plugins.mini.ai" },
  { import = "plugins.mini.files" },
}
