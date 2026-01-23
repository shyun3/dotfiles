return {
  {
    LazyDep("blink.cmp"),
    optional = true,

    opts = {
      completion = {
        menu = {
          draw = {
            components = {
              -- Derived from https://cmp.saghen.dev/recipes#nvim-web-devicons-lspkind
              kind_icon = {
                text = function(ctx)
                  return require("lspkind").symbolic(
                    ctx.kind,
                    { mode = "symbol" }
                  ) .. ctx.icon_gap
                end,
              },
            },
          },
        },
      },
    },
  },

  { "onsails/lspkind.nvim", lazy = true },
}
