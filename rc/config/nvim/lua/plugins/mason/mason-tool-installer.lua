return {
  {
    LazyDep("mason-lspconfig"),
    optional = true,

    opts = {
      automatic_enable = {
        exclude = {
          "stylua", -- Only for formatting
        },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Ensure installed does not work on VeryLazy, see #39
    lazy = false,

    opts = {
      ensure_installed = {
        -- Formatters
        "black",
        { "clang-format", version = "21.1.7" },
        "isort",
        "prettier",
        "shfmt",
        "stylua",

        -- Linters
        "shellcheck",
      },

      integrations = {
        ["mason-lspconfig"] = false, -- To allow lazy loading
      },
    },
  },
}
