--- Plugin dependents/dependencies that are referenced in more than one
--- location
---
---@type table<string, string> plugin: lazy.nvim URL
local deps = {
  -- Vim plugins
  ["vim-endwise"] = "shyun3/vim-endwise",
  ["vim-grepper"] = "shyun3/vim-grepper",
  ["vim-project"] = "shyun3/vim-project",

  -- Lua modules
  ["blink.cmp"] = "saghen/blink.cmp",
  Comment = "numToStr/Comment.nvim",
  dropbar = "Bekaboo/dropbar.nvim",
  ["goto-preview"] = "rmagatti/goto-preview",
  ibl = "lukas-reineke/indent-blankline.nvim",
  lspconfig = "neovim/nvim-lspconfig",
  lualine = "nvim-lualine/lualine.nvim",
  ["mason-tool-installer"] = "WhoIsSethDaniel/mason-tool-installer.nvim",
  ["mini.files"] = "echasnovski/mini.files",
  noice = "folke/noice.nvim",
  ["mason-lspconfig"] = "mason-org/mason-lspconfig.nvim",
  ["nvim-autopairs"] = "windwp/nvim-autopairs",
  ["nvim-surround"] = "kylechui/nvim-surround",
  ["nvim-treesitter-jjconfig"] = "acarapetis/nvim-treesitter-jjconfig",
  oil = "stevearc/oil.nvim",
  tabby = "nanozuki/tabby.nvim",
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
