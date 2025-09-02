return {
  {
    "mason-org/mason.nvim", -- Must be loaded before all Mason plugins

    -- PATH should be updated early
    priority = 100,

    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Ensure installed does not work on VeryLazy, see #39
    event = "VimEnter",

    opts = {
      ensure_installed = {
        -- Formatters
        "black",
        { "clang-format", version = "21.1.0" },
        "isort",
        "prettier",
        "shfmt",
        "stylua",

        -- Linters
        "shellcheck",
      },
    },
  },

  { import = "plugins.mason.mason-lspconfig" },
}
