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
                _my_text = { LazyDev = "[LD]" },
              },
            },
          },
        },
      },

      sources = {
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },

        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",

    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
