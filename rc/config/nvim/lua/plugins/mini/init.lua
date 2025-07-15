return {
  {
    "echasnovski/mini.ai",
    version = false, -- Main branch
    event = "ModeChanged",

    opts = {
      custom_textobjects = {
        -- Disable built-in text objects
        ["("] = false,
        ["["] = false,
        ["{"] = false,
        ["<"] = false,
        [")"] = false,
        ["]"] = false,
        ["}"] = false,
        [">"] = false,
        b = false,
        ['"'] = false,
        ["'"] = false,
        ["`"] = false,
        t = false,
        f = false, -- See treesitter text objects
        a = false, -- See vim-textobj-parameter
      },
    },
  },

  { import = "plugins.mini.files" },
}
