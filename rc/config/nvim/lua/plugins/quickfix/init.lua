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
          end
          return ret
        end,
      },
      func_map = {
        -- These don't seem to open in the last focused window
        open = "",
        openc = "",
        drop = "",

        -- These mappings close the quickfix list
        split = "<C-x><C-s>",
        vsplit = "<C-x><C-v>",

        fzffilter = "",
      },
    },
  },

  { import = "plugins.quickfix.qfenter" },
}
