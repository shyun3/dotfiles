-- Derived from https://github.com/kevinhwang91/nvim-bqf/issues/85#issuecomment-1298008156
local function qf_sort()
  local qf = vim.fn.getqflist({ items = 0, title = 0 })
  table.sort(qf.items, function(a, b)
    if a.bufnr == b.bufnr then
      if a.lnum == b.lnum then
        return a.col < b.col
      else
        return a.lnum < b.lnum
      end
    else
      return vim.fn.bufname(a.bufnr) < vim.fn.bufname(b.bufnr)
    end
  end)
  vim.fn.setqflist({}, "r", qf)
end

return {
  "mhinz/vim-grepper",

  config = function()
    -- Initialize g:grepper with default values
    vim.cmd.runtime("plugin/grepper.vim")

    do
      local grepper = vim.g.grepper

      grepper.tools = { "rg", "git" }
      grepper.rg.grepprg = "rg -H --no-heading --vimgrep --smart-case --follow"
      grepper.dir = "filecwd"

      -- Prevent auto-resize of quickfix window
      grepper.open = 0

      grepper.operator.prompt = 1

      vim.g.grepper = grepper
    end

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("myGrepperGroup", {}),
      pattern = "Grepper",
      nested = true,

      callback = function()
        -- Although ripgrep has a sort option, it reduces performance
        qf_sort()

        vim.cmd("botright copen")
      end,
    })
  end,

  keys = {
    {
      "<Leader><Leader>",
      function()
        require("util").go_to_editable_window()
        vim.cmd.Grepper()
      end,
      desc = "Grepper: Prompt",
    },
    { "<Leader>*", "<Cmd>Grepper -cword<CR>" },
    { "gs", "<Plug>(GrepperOperator)", mode = { "n", "x" } },
  },
}
