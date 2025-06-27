return {
  "saghen/blink.cmp",
  version = "1.*",

  opts = {
    keymap = { preset = "enter" },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
