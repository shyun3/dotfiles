return {
  {
    "mason-org/mason.nvim",

    -- PATH should be updated early
    priority = 100,

    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
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
        { "clang-format", version = "20.1.7" },
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
