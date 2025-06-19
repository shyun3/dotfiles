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
    dependencies = { "mason-org/mason.nvim" },

    opts = {
      ensure_installed = {
        -- Formatters
        "black",
        { "clang-format", version = "20.1.6" },
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
