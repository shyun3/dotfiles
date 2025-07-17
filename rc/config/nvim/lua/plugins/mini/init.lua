return {
  {
    "echasnovski/mini.ai",
    version = false, -- Main branch
    event = "ModeChanged",

    opts = {
      custom_textobjects = {
        f = false, -- See treesitter text objects
      },

      mappings = {
        around_next = "",
        inside_next = "",
        around_last = "",
        inside_last = "",
      },

      search_method = "cover",
    },
  },

  { import = "plugins.mini.files" },
}
