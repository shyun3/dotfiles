return {
  {
    "williamboman/mason.nvim",

    -- PATH should be updated early
    priority = 100,

    config = true,
  },

  {
    "zapling/mason-lock.nvim",
    dependencies = { "williamboman/mason.nvim" },

    opts = {},
  },

  {
    "zapling/mason-conform.nvim",
    dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },

    opts = {},
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

    opts = { ensure_installed = { "shellcheck" } },
  },
}
