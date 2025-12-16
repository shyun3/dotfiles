--- Plugin dependents/dependencies that are referenced in more than one
--- location
---
---@type table<string, string> plugin: lazy.nvim URL
local deps = {
  -- Vim plugins
  ["vim-endwise"] = "shyun3/vim-endwise",

  -- Lua modules
  lspconfig = "neovim/nvim-lspconfig",
  ["nvim-autopairs"] = "windwp/nvim-autopairs",
  oil = "stevearc/oil.nvim",
  ["which-key"] = "folke/which-key.nvim",
}

--- Gets the lazy.nvim URL corresponding to the given plugin name
---
--- Throws an error if plugin was not found
---
---@param plugin string
---
---@return string? URL
function LazyDep(plugin) return deps[plugin] or error("Invalid plugin") end
