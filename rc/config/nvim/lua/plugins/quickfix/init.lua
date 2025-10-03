return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",

    opts = {
      preview = {
        should_preview_cb = function(bufnr)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        -- These mappings close the quickfix list
        split = "<C-x><C-s>",
        vsplit = "<C-x><C-v>",

        fzffilter = "",
      },
    },

    config = function(_, opts)
      require("bqf").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_bqf", {}),
        pattern = "qf",

        callback = function()
          local util = require("util")

          -- Plugin only creates mouse click mappings after a delay
          -- See bqf/preview/handler.lua
          vim.defer_fn(function()
            util.update_keymap_desc("n", "<LeftMouse>", "Preview item")
            util.update_keymap_desc("n", "<2-LeftMouse>", "Open item")
          end, 250)
        end,

        desc = "bqf: Update keymap descriptions",
      })
    end,
  },

  { import = "plugins.quickfix.qfenter" },
}
