return {
  "amiorin/vim-project",
  dependencies = "stevearc/oil.nvim",
  event = "VimEnter",

  config = function()
    vim.call("project#rc")

    -- Execute vim-project autocommands for paths in oil.nvim buffers
    local group = vim.api.nvim_create_augroup("user_project", {})
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = "oil://*",
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
        callback = function()
          if vim.fn.winnr() ~= 1 then return end

          -- Derived from project.vim
          if vim.fn.line2byte(vim.fn.line("$")) == -1 then vim.cmd.Welcome() end
        end,
      })
    end
  end,
}
