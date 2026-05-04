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

    -- let the plugin lazy load itself
    lazy = false,

    opts = {
      winbar = { default_section = "scopes" },
      auto_toggle = true,
    },

    config = function(_, opts)
      local winbar_opts = require("dap-view.options.winbar")

      --- To add desc to winbar keymaps, see PR #183
      ---
      ---@diagnostic disable-next-line: duplicate-set-field
      winbar_opts.set_action_keymaps = function(bufnr)
        local setup = require("dap-view.setup")
        local state = require("dap-view.state")
        if bufnr or state.bufnr then
          local winbar = setup.config.winbar

          for k, view in pairs(winbar.sections) do
            local section = winbar.custom_sections[view]
              or winbar.base_sections[view]

            if section == nil then
              vim.notify_once(
                "View '" .. view .. "' not found, skipping setup",
                vim.log.levels.WARN
              )
              winbar.sections[k] = nil
            else
              local label = type(section.label) == "string" and section.label
                or nil
              ---@cast label string?

              vim.keymap.set(
                "n",
                section.keymap,
                function() winbar_opts.wrapped_action(view) end,
                { buffer = bufnr or state.bufnr, desc = label }
              )
            end
          end
        end
      end

      require("dap-view").setup(opts)
    end,
  },
}
