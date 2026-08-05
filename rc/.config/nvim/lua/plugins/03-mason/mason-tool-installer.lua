return {
  {
    LazyDep("mason-tool-installer"),

    -- Ensure installed does not work on VeryLazy, see #39
    lazy = false,

    opts = {
      ensure_installed = {
        -- Formatters
        "black",
        "prettier",
        "shfmt",

        -- Linters
        "shellcheck",
      },
    },
  },
}
