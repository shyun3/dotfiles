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
      },
    },
  },

  {
    "yssl/QFEnter",

    init = function()
      vim.g.qfenter_keymap = {
        open = {},
        vopen = { "<C-v>" },
        hopen = { "<C-s>" },
        topen = {},
      }
    end,

    ft = "qf",

    config = function()
      -- This plugin creates its mappings in quickfix lists through an
      -- autocommand, so update the descriptions afterwards
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_qfenter", {}),
        pattern = "qf",

        callback = function()
          local util = require("util")
          util.update_keymap_desc("n", "<C-s>", "Open item in horizontal split")
          util.update_keymap_desc("n", "<C-v>", "Open item in vertical split")

          util.update_keymap_desc(
            "v",
            "<C-s>",
            "Open highlighted items in horizontal splits"
          )
          util.update_keymap_desc(
            "v",
            "<C-v>",
            "Open highlighted items in vertical splits"
          )
        end,

        desc = "QFEnter: Update mapping descriptions",
      })
    end,
  },
}
