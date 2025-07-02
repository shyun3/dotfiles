vim.diagnostic.config({
  virtual_text = true,

  signs = {
    text = {
      -- Taken from lualine diagnostics component default symbols
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
})
