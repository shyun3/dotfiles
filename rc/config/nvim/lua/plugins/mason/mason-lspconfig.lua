return {
  {
    LazyDep("mason-tool-installer"),
    optional = true,

    opts = {
      integrations = {
        ["mason-lspconfig"] = false, -- To allow lazy loading
      },
    },
  },

  {
    LazyDep("mason-lspconfig"),
    event = "VeryLazy",

    opts_extend = { "ensure_installed", "automatic_enable.exclude" },

    opts = {
      ensure_installed = {
        "basedpyright",
        "bashls",
        "jsonls",
        "mesonlsp",
        "taplo",
        "ts_query_ls",
        "vimls",
        "yamlls",
      },
    },

    config = function(_, opts)
      local my_lsp_configs = opts._my_lsp_configs
      if my_lsp_configs then
        for lsp, config in pairs(my_lsp_configs) do
          if not vim.list_contains(opts.ensure_installed or {}, lsp) then
            local msg = "mason-lspconfig: "
              .. ("Custom LSP config for '%s' found, "):format(lsp)
              .. "but server is not ensured to be installed"
            vim.notify(msg, vim.log.levels.WARN)
          end

          vim.lsp.config(lsp, config)
        end
      end

      require("mason-lspconfig").setup(opts)
    end,
  },
}
