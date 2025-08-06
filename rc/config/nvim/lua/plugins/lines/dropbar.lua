return {
  "Bekaboo/dropbar.nvim",
  event = "BufWinEnter",

  opts = {
    bar = {
      -- Derived from default bar enable function
      enable = function(buf, win)
        -- Note that the buffer filetype may return blank when this function is
        -- called. Maybe a default attach event gets fired before the filetype
        -- is detected.
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or vim.fn.win_gettype(win) ~= ""
          or vim.wo[win].winbar ~= ""
          or vim.bo[buf].ft == "oil"
          or vim.bo[buf].buftype == "help"
          or vim.fn.bufname(buf) == "" -- Also applies to project welcome
        then
          return false
        end

        local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
        if stat and stat.size > 1024 * 1024 then return false end

        -- Always show path
        return true
      end,
    },

    icons = {
      ui = {
        bar = {
          separator = " › ", -- Taken from lspsaga
        },
      },
    },

    sources = {
      path = { max_depth = 1 },
    },
  },

  keys = {
    {
      "[;",
      function() require("dropbar.api").goto_context_start() end,
      desc = "Go to start of current context",
    },
  },
}
