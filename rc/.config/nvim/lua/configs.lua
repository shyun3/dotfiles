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

  float = { border = "single" },
  jump = { on_jump = function() vim.diagnostic.open_float() end },
})
