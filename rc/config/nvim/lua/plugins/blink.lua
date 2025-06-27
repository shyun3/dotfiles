return {
  "saghen/blink.cmp",
  version = "1.*",

  opts = {
    keymap = { preset = "enter" },

    completion = {
      list = { selection = { preselect = false } },

      menu = {
        -- nvim-cmp style menu
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
        },
      },

      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    snippets = { preset = "luasnip" },
  },
}
