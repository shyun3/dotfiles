return {
  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        dropbar = {
          DropBarKindFile = { link = "Comment" },
          DropBarKindDir = { link = "Comment" },

          -- Must be different from WinBar for dimming to be enabled
          -- See dropbar/hlgroups.lua
          WinBarNC = { link = "Comment" },
        },
      },

      integrations = {
        dropbar = { color_mode = true },
      },
    },
  },

  {
    LazyDep("dropbar"),
    event = "UIEnter",

    opts = {
      bar = {
        -- Derived from default bar enable function
        enable = function(buf, win)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].winbar ~= ""
            or vim.fn.bufname(buf) == ""
            or vim.bo[buf].ft == "help"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then return false end

          return true -- Always show path
        end,
      },

      icons = {
        ui = {
          bar = {
            separator = " › ", -- Taken from lspsaga
          },
        },
      },

      sources = { path = { max_depth = 2 } },
    },

    keys = {
      {
        "[;",
        function() require("dropbar.api").goto_context_start() end,
        desc = "Go to start of current context",
      },
    },
  },
}
