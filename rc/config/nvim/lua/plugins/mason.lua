return {
  {
    "mason-org/mason.nvim", -- Must be loaded before all Mason plugins

    -- PATH should be updated early
    priority = 100,

    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",

    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "jsonls",
        "lua_ls",
        "pyright",
        "vimls",
        "yamlls",
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",

    opts = {
      ensure_installed = {
        -- Formatters
        "black",
        { "clang-format", version = "20.1.8" },
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
