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
      command = "botright copen",
      nested = true,
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
