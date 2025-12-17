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
    LazyDep("mason-tool-installer"),

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
    },
  },
}
