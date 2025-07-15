-- Derived from https://github.com/L3MON4D3/LuaSnip/issues/656#issuecomment-1500869758
local function stop_snippet()
  -- If we have n active nodes, n - 1 will still remain after a `unlink_current()` call.
  -- We unlink all of them by wrapping the calls in a loop.
  local luasnip = require("luasnip")
  while true do
    if
      luasnip.session
      and luasnip.session.current_nodes[vim.fn.bufnr()]
      and not luasnip.session.jump_active
    then
      luasnip.unlink_current()
    else
      break
    end
  end
end

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",

  opts = {
    -- Update repeated placeholders while typing in insert mode
    -- Derived from https://github.com/L3MON4D3/LuaSnip/wiki/Migrating-from-UltiSnips#update-placeholders
    update_events = { "TextChanged", "TextChangedI" },
  },

  config = function(_, opts)
    for _, fmt in ipairs({ "vscode", "snipmate" }) do
      local module = string.format("luasnip.loaders.from_%s", fmt)
      require(module).lazy_load({
        lazy_paths = { "./snippets/specific" },
      })
    end

    require("luasnip").setup(opts)
  end,

  keys = {
    -- LuaSnip keeps a snippet session active if all the placeholders aren't
    -- replaced, even if insert mode is left. This mapping is to manually end
    -- a session.
    {
      -- Derived from https://github.com/Saghen/blink.cmp/issues/1805#issuecomment-2912427954
      "<Esc>",

      function()
        stop_snippet()
        return "<Esc>"
      end,

      mode = { "n", "i", "s" },
      silent = true,
      expr = true,
      desc = "Escape and stop snippet",
    },
  },
}
