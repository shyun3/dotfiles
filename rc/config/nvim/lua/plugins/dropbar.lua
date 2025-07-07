local function highlight_dropbar_text()
  local link_hl = require("util").link_hl

  -- Derived from catppuccin dropbar integration
  -- See also dropbar#18
  link_hl("DropBarKindArray", "DropBarIconKindArray")
  link_hl("DropBarKindBoolean", "DropBarIconKindBoolean")
  link_hl("DropBarKindBreakStatement", "DropBarIconKindBreakStatement")
  link_hl("DropBarKindCall", "DropBarIconKindCall")
  link_hl("DropBarKindCaseStatement", "DropBarIconKindCaseStatement")
  link_hl("DropBarKindClass", "DropBarIconKindClass")
  link_hl("DropBarKindConstant", "DropBarIconKindConstant")
  link_hl("DropBarKindConstructor", "DropBarIconKindConstructor")
  link_hl("DropBarKindContinueStatement", "DropBarIconKindContinueStatement")
  link_hl("DropBarKindDeclaration", "DropBarIconKindDeclaration")
  link_hl("DropBarKindDelete", "DropBarIconKindDelete")
  link_hl("DropBarKindDoStatement", "DropBarIconKindDoStatement")
  link_hl("DropBarKindElseStatement", "DropBarIconKindElseStatement")
  link_hl("DropBarKindEnum", "DropBarIconKindEnum")
  link_hl("DropBarKindEnumMember", "DropBarIconKindEnumMember")
  link_hl("DropBarKindEvent", "DropBarIconKindEvent")
  link_hl("DropBarKindField", "DropBarIconKindField")
  link_hl("DropBarKindForStatement", "DropBarIconKindForStatement")
  link_hl("DropBarKindFunction", "DropBarIconKindFunction")
  link_hl("DropBarKindIdentifier", "DropBarIconKindIdentifier")
  link_hl("DropBarKindIfStatement", "DropBarIconKindIfStatement")
  link_hl("DropBarKindInterface", "DropBarIconKindInterface")
  link_hl("DropBarKindKeyword", "DropBarIconKindKeyword")
  link_hl("DropBarKindList", "DropBarIconKindList")
  link_hl("DropBarKindMacro", "DropBarIconKindMacro")
  link_hl("DropBarKindMarkdownH1", "DropBarIconKindMarkdownH1")
  link_hl("DropBarKindMarkdownH2", "DropBarIconKindMarkdownH2")
  link_hl("DropBarKindMarkdownH3", "DropBarIconKindMarkdownH3")
  link_hl("DropBarKindMarkdownH4", "DropBarIconKindMarkdownH4")
  link_hl("DropBarKindMarkdownH5", "DropBarIconKindMarkdownH5")
  link_hl("DropBarKindMarkdownH6", "DropBarIconKindMarkdownH6")
  link_hl("DropBarKindMethod", "DropBarIconKindMethod")
  link_hl("DropBarKindModule", "DropBarIconKindModule")
  link_hl("DropBarKindNamespace", "DropBarIconKindNamespace")
  link_hl("DropBarKindNull", "DropBarIconKindNull")
  link_hl("DropBarKindNumber", "DropBarIconKindNumber")
  link_hl("DropBarKindObject", "DropBarIconKindObject")
  link_hl("DropBarKindOperator", "DropBarIconKindOperator")
  link_hl("DropBarKindPackage", "DropBarIconKindPackage")
  link_hl("DropBarKindProperty", "DropBarIconKindProperty")
  link_hl("DropBarKindReference", "DropBarIconKindReference")
  link_hl("DropBarKindRepeat", "DropBarIconKindRepeat")
  link_hl("DropBarKindScope", "DropBarIconKindScope")
  link_hl("DropBarKindSpecifier", "DropBarIconKindSpecifier")
  link_hl("DropBarKindStatement", "DropBarIconKindStatement")
  link_hl("DropBarKindString", "DropBarIconKindString")
  link_hl("DropBarKindStruct", "DropBarIconKindStruct")
  link_hl("DropBarKindSwitchStatement", "DropBarIconKindSwitchStatement")
  link_hl("DropBarKindType", "DropBarIconKindType")
  link_hl("DropBarKindTypeParameter", "DropBarIconKindTypeParameter")
  link_hl("DropBarKindUnit", "DropBarIconKindUnit")
  link_hl("DropBarKindValue", "DropBarIconKindValue")
  link_hl("DropBarKindVariable", "DropBarIconKindVariable")
  link_hl("DropBarKindWhileStatement", "DropBarIconKindWhileStatement")

  link_hl("DropBarKindFile", "Comment")
  link_hl("DropBarKindFolder", "Comment")
end

return {
  "Bekaboo/dropbar.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "BufWinEnter",

  opts = {
    icons = {
      ui = {
        bar = {
          -- Taken from lspsaga
          separator = " › ",
        },
      },
    },

    sources = {
      path = { max_depth = 1 },
    },
  },

  config = function(_, opts)
    highlight_dropbar_text()
    require("dropbar").setup(opts)
  end,

  keys = {
    {
      "[;",
      function() require("dropbar.api").goto_context_start() end,
      desc = "Go to start of current context",
    },
  },
}
