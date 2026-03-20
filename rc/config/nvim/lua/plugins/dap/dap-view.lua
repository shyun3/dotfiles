return {
  {
    LazyDep("tabby"),
    optional = true,

    opts = {
      option = {
        tab_name = {
          _my_name_fallbacks = { ["dap-view"] = "[DAP]" },
        },
      },
    },
  },

  {
    "igorlfs/nvim-dap-view",
    version = "1.*",

    -- let the plugin lazy load itself
    lazy = false,

    opts = {
      winbar = { default_section = "scopes" },
      auto_toggle = true,
    },
  },
}
