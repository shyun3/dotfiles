return {
  {
    "echasnovski/mini.ai",
    version = false, -- Main branch
    dependencies = "echasnovski/mini.extra",
    event = "ModeChanged",

    config = function()
      local gen_ai_spec = require("mini.extra").gen_ai_spec

      require("mini.ai").setup({
        custom_textobjects = {
          f = false, -- See treesitter text objects

          g = gen_ai_spec.buffer(),
          i = gen_ai_spec.indent(),
        },

        mappings = {
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
        },

        search_method = "cover",
      })
    end,
  },

  { "echasnovski/mini.extra", version = false, lazy = true, config = true },

  { import = "plugins.mini.files" },
}
