return {
  {
    LazyDep("dap"),
    lazy = true,

    config = function(_, opts)
      if not opts then return end

      local dap = require("dap")
      dap.defaults.fallback.switchbuf = "usetab,uselast"

      for lang, cfg in pairs(opts._my_configs) do
        dap.configurations[lang] = cfg
      end

      for lang, cfg in pairs(opts._my_adapters) do
        dap.adapters[lang] = cfg
      end
    end,
  },

  { import = "plugins.dap.osv" },
}
