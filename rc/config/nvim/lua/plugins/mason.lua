return {
  {
    "williamboman/mason.nvim",

    -- PATH should be updated early
    priority = 100,

    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },

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
      automatic_installation = true,
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },

    opts = {
      ensure_installed = {
        -- Formatters
        "black",
        { "clang-format", version = "19.1.6" },
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
