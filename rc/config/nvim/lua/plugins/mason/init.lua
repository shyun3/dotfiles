return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- Lazy loading is not recommended

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
        ["mason-lspconfig"] = false, -- To allow lazy loading
      },
    },
  },

  { import = "plugins.mason.mason-lspconfig" },
}
