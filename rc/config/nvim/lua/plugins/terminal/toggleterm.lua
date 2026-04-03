local OPEN_MAPPING = "<Leader>t"

--- Helper to create a new floating terminal and open it
---
---@param cmd string By default, this is also used as the terminal's name
---@param args TermCreateArgs? Overrides all parameters and defaults
local function make_float_term(cmd, args)
  local defaults = {
    cmd = cmd,
    display_name = cmd,
    direction = "float",
    float_opts = { border = "rounded" },
  }

  local term_args = vim.tbl_deep_extend("force", defaults, args or {})
  require("toggleterm.terminal").Terminal:new(term_args):open()
end

return {
  {
    LazyDep("flatten"),
    optional = true,

    opts = {
      -- Derived from https://github.com/willothy/flatten.nvim#toggleterm
      hooks = {
        pre_open = function(ctx)
          local toggleterm = require("toggleterm.terminal")
          local id = toggleterm.get_focused_id()
          ctx.data.term = toggleterm.get(id)
        end,

        post_open = function(ctx)
          local term = ctx.data.term
          if ctx.is_blocking and term and term:is_float() then term:close() end
        end,

        block_end = function(ctx)
          local term = ctx.data.term
          if term then
            -- Using schedule, otherwise terminal may not get reopened
            vim.schedule(function() term:open() end)
          end
        end,
      },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",

    opts = {
      open_mapping = OPEN_MAPPING,
      insert_mappings = false,
      terminal_mappings = false,

      shade_terminals = false,
    },

    keys = {
      OPEN_MAPPING,

      {
        "<Leader>lg",
        function() make_float_term("lazygit") end,
        desc = "Open lazygit",
      },

      {
        "<Leader>lf",

        function()
          local file = vim.api.nvim_buf_get_name(0)
          make_float_term("lazygit -f " .. vim.fn.shellescape(file), {
            dir = vim.fn.fnamemodify(file, ":h"),
          })
        end,

        desc = "lazygit: Open log for current file",
      },

      {
        "<Leader>j",
        function() make_float_term("jjui") end,
        desc = "Open jjui",
      },
    },
  },
}
