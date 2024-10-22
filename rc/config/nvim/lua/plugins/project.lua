return {
  "amiorin/vim-project",

  config = function()
    vim.fn["project#rc"]()
    vim.cmd.source(vim.fn.stdpath("config") .. "/projects.vim")

    if vim.fn.argc(-1) == 0 then
      local group = vim.api.nvim_create_augroup("project", {})

      -- Show welcome screen on startup, making sure to display it on the main
      -- window and not in the Lazy floating window which pops up when
      -- installing missing plugins
      vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
        group = group,
        pattern = "*",
        callback = function()
          if vim.fn.winnr() ~= 1 then return end

          -- Derived from project.vim
          if vim.fn.line2byte(vim.fn.line("$")) == -1 then vim.cmd.Welcome() end

          vim.api.nvim_clear_autocmds({ group = group })
        end,
      })
    end
  end,
}
