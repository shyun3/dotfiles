return {
  {
    LazyDep("blink.cmp"),
    optional = true,

    opts = {
      completion = {
        menu = {
          draw = {
            components = {
              source_name = {
                _my_text = { Ctags = "[T]" },
              },
            },
          },
        },
      },

      sources = {
        default = { "ctags" },

        providers = {
          lsp = {
            fallbacks = { "ctags" },
          },

          ctags = {
            name = "Ctags",
            module = "blink-cmp-ctags",
          },
        },
      },
    },
  },

  { "shyun3/blink-cmp-ctags", lazy = true },
}
