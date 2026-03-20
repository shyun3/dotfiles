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
    lazy = false, -- To debug plugins on startup
    priority = 5000, -- Highest, to debug any plugin

    config = function()
      --- See `:h osv-init-debug`
      ---@diagnostic disable-next-line: undefined-field
      if _G.init_debug then
        require("osv").launch({ port = 8086, blocking = true })
      end
    end,

    keys = {
      {
        "<Leader>Do",
        function() require("osv").launch({ port = 8086 }) end,
        desc = "osv: Launch",
      },
    },
  },
}
