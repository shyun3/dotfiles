--- @type table<string, vim.lsp.Config>
local lsp_client_configs = {
  ts_query_ls = {
    settings = {
      -- Taken from `ts_query_ls` entry in `lspconfig-all`
      parser_install_directories = {
        -- If using nvim-treesitter with lazy.nvim
        vim.fs.joinpath(
          vim.fn.stdpath("data"),
          "/lazy/nvim-treesitter/parser/"
        ),
      },
    },
  },
}

return {
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
      "tombi",
      "ts_query_ls",
      "vimls",
      "yamlls",
    },
  },

  config = function(_, opts)
    for client, cfg in pairs(lsp_client_configs) do
      vim.lsp.config(client, cfg)
    end

    -- Enable LSP servers after configs
    require("mason-lspconfig").setup(opts)
  end,
}
