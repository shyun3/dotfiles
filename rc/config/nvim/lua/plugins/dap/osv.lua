return {
  {
    LazyDep("dap"),
    optional = true,

    opts = {
      _my_configs = {
        lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
          },
        },
      },

      _my_adapters = {
        nlua = function(callback, config)
          callback({
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or 8086,
          })
        end,
      },
    },
  },

  {
    "jbyuki/one-small-step-for-vimkind",

    keys = {
      {
        "<Leader>D",
        function() require("osv").launch({ port = 8086 }) end,
        desc = "osv: Launch",
      },
    },
  },
}
