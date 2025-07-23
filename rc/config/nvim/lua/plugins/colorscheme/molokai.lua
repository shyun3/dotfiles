local function highlight_cmp_menu()
  -- Some colors taken from:
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu

  local link_hl = require("util").link_hl
  link_hl("BlinkCmpLabelDeprecated", "@lsp.mod.deprecated")

  -- Taken from CocSearch
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#15aabf" })

  -- Taken from CocMenuSel
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#13354A" })

  -- gray
  vim.api.nvim_set_hl(0, "BlinkCmpSource", { bg = "NONE", fg = "#808080" })

  link_hl("BlinkCmpKindFunction", "@lsp.type.function")
  link_hl("BlinkCmpKindMethod", "@lsp.type.method")
  link_hl("BlinkCmpKindConstructor", "BlinkCmpKindMethod")

  link_hl("BlinkCmpKindText", "String")

  link_hl("BlinkCmpKindProperty", "@lsp.type.property")
  link_hl("BlinkCmpKindField", "BlinkCmpKindProperty")

  link_hl("BlinkCmpKindVariable", "@lsp.type.variable")
  link_hl("BlinkCmpKindTypeParameter", "@lsp.type.parameter")
  link_hl("BlinkCmpKindReference", "BlinkCmpKindVariable")

  link_hl("BlinkCmpKindClass", "@lsp.type.class")
  link_hl("BlinkCmpKindStruct", "@lsp.type.struct")
  link_hl("BlinkCmpKindInterface", "@lsp.type.interface")
  link_hl("BlinkCmpKindEnum", "@lsp.type.enum")

  link_hl("BlinkCmpKindKeyword", "@lsp.type.keyword")
  link_hl("BlinkCmpKindOperator", "@lsp.type.operator")

  -- front
  vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { bg = "NONE", fg = "#D4D4D4" })

  link_hl("BlinkCmpKindModule", "@lsp.type.namespace")

  -- pink
  vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { bg = "NONE", fg = "#C586C0" })
  link_hl("BlinkCmpKindFolder", "BlinkCmpKindFile")

  link_hl("BlinkCmpKindEnumMember", "@lsp.type.enumMember")
  link_hl("BlinkCmpKindConstant", "BlinkCmpKindEnumMember")

  link_hl("BlinkCmpKindEvent", "@lsp.type.event")
end

local function highlight_dropbar_text()
  local dropbar = require("plugins.colorscheme.integrations").dropbar_custom
  for group, hl_map in pairs(dropbar) do
    vim.api.nvim_set_hl(0, group, hl_map)
  end
end

local function highlight_indent_blankline()
  -- Taken from default vscode theme (Dark Modern)
  vim.cmd.highlight("IblIndent guifg=#404040")
  vim.cmd.highlight("IblScope guifg=#707070")
end

return {
  -- the colorscheme should be available when starting Neovim
  "shyun3/molokai",
  branch = "personal",

  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins

  config = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("molokai", {}),
      pattern = "molokai",

      callback = function()
        -- See `:h treesitter-highlight-groups`
        vim.api.nvim_set_hl(0, "@variable", { fg = "fg" })
        vim.cmd.highlight("link @variable.parameter NONE")

        -- See `:h lsp-semantic-highlight`
        vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "fg" })
        vim.cmd.highlight("link @lsp.type.parameter NONE")

        -- Work around nvim 0.11 statusline changes, see neovim PR #29976
        -- Derived from https://github.com/vim-airline/vim-airline/issues/2693#issuecomment-2424151997
        vim.cmd.highlight("TabLine cterm=NONE gui=NONE")
        vim.cmd.highlight("TabLineFill cterm=NONE gui=NONE")

        highlight_cmp_menu()
        highlight_dropbar_text()
        highlight_indent_blankline()
      end,

      desc = "Apply Molokai highlights",
    })
  end,
}
