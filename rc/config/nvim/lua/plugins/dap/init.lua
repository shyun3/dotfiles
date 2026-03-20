return {
  {
    LazyDep("dap"),

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

    -- Derived from https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/bare/nvim-dap.lua
    keys = function()
      local dap = require("dap")
      return {
        {
          "<F4>",
          function() dap.terminate({ hierarchy = true }) end,
          desc = "DAP: Terminate",
        },
        { "<F5>", dap.continue, desc = "DAP: Continue" },
        { "<F9>", dap.toggle_breakpoint, desc = "DAP: Toggle breakpoint" },
        { "<F10>", dap.step_over, desc = "DAP: Step over" },
        { "<F11>", dap.step_into, desc = "DAP: Step into" },
        { "<F12>", dap.step_out, desc = "DAP: Step out" },

        { "<Leader>Dc", dap.run_to_cursor, desc = "DAP: Run to cursor" },
        {
          "<Leader>Dx",
          dap.clear_breakpoints,
          desc = "DAP: Clear all breakpoints",
        },
      }
    end,
  },

  { import = "plugins.dap.osv" },
}
