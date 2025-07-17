return {
  {
    "echasnovski/mini.ai",
    version = false, -- Main branch
    dependencies = {
      { "echasnovski/mini.extra", version = false, config = true },
    },

    event = "ModeChanged",

    config = function()
      local mini_ai = require("mini.ai")

      local spec_treesitter = mini_ai.gen_spec.treesitter
      local gen_ai_spec = require("mini.extra").gen_ai_spec

      mini_ai.setup({
        custom_textobjects = {
          f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          k = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),

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

  { import = "plugins.mini.files" },
}
