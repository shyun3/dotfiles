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
      desc = "Show sorted results",

      callback = function()
        local curr_qf = vim.fn.getqflist({ items = 0, title = 0 })

        -- Although ripgrep has a sort option, it reduces performance
        require("util").sort_qf_list(curr_qf.items)

        vim.fn.setqflist({}, "r", curr_qf)

        vim.cmd("botright copen")
      end,
    })
  end,

  keys = {
    {
      "<Leader><Leader>",

      function()
        require("util").go_to_editable_window()

        -- When using 'file' or 'filecwd' for the `grepper.dir` option, Grepper
        -- will throw an error if run on an oil buffer. For this case, just use
        -- the current directory.
        local cd_flag = vim.bo.filetype == "oil" and "-cd " .. vim.fn.getcwd()
          or ""
        vim.cmd("Grepper " .. cd_flag)
      end,

      desc = "Grepper: Prompt",
    },
    {
      "<Leader>*",
      "<Cmd>Grepper -cword<CR>",
      desc = "Grepper: Search for current word",
    },
    {
      "gs",
      "<Plug>(GrepperOperator)",
      mode = { "n", "x" },
      desc = "Grepper: Search",
    },
  },
}
