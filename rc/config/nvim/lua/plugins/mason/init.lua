return {
  {
    "mason-org/mason.nvim", -- Must be loaded before all Mason plugins

    -- PATH should be updated early
    priority = 100,

    opts = {},

    keys = {
      { "<Leader>mm", "<Cmd>Mason<CR>" },
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
        -- To allow lazy loading of mason-lspconfig
        ["mason-lspconfig"] = false,
      },
    },
  },

  { import = "plugins.mason.mason-lspconfig" },
}
