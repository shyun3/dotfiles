return {
  "igorlfs/nvim-dap-view",
  version = "1.*",

  -- let the plugin lazy load itself
  lazy = false,

  opts = {
    winbar = {
      default_section = "scopes",
    },

    auto_toggle = true,
  },
}
