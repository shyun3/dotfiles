local M = vim.deepcopy(require("lualine.extensions.oil"))

M.sections = {
  lualine_a = { "mode" },
  lualine_b = { { "vcs", draw_empty = true } },
  lualine_c = { M.sections.lualine_a[1] },

  lualine_x = { require("plugins.lualine.filetype") },
  lualine_z = { "my_progress", "my_location" },
}

return M
