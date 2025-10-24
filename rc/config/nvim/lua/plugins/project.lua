return {
  {
    require("lazy-deps").which_key,

    opts = {
      spec = {
        { "<Leader>p", desc = "Project" },
      },
    },
  },

  {
    "shyun3/vim-project",
    branch = "personal",

    lazy = false, -- To show welcome screen on startup

    init = function()
      vim.g.project_enable_welcome = 0 -- Handled in config
    end,

    config = function()
      vim.call("project#rc")

      local group = vim.api.nvim_create_augroup("user_project", {})
      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "oil://*",
        desc = "Execute vim-project autocommand",

        callback = function(args)
          vim.cmd.doautocmd({
            "vim_project",
            "BufEnter",
            require("util").oil_filter(args.file),
          })
        end,
      })

      local projects = vim.fn.stdpath("config") .. "/projects.vim"
      if vim.fn.filereadable(projects) == 0 then return end

      vim.cmd.source(projects)

      if vim.fn.argc(-1) == 0 then
        -- Show welcome screen on startup, making sure to display it on the main
        -- window and not in the Lazy floating window which pops up when
        -- installing missing plugins
        vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
          group = group,
          pattern = "*",
          once = true,
          desc = "Show vim-project welcome screen",

          callback = function()
            if vim.fn.winnr() ~= 1 then return end

            -- Derived from project.vim
            if vim.fn.line2byte(vim.fn.line("$")) == -1 then
              vim.cmd.Welcome()
            end
          end,
        })
      end
    end,

    keys = {
      { "<Leader>pw", "<Cmd>Welcome<CR>" },
      {
        "<Leader>pt",
        "<Cmd>tabedit | Welcome<CR>",
        desc = "Welcome in new tab",
      },
    },
  },
}
