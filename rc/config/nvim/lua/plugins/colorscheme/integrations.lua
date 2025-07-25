local M = {}

--- Derived from catppuccin dropbar integration
--- See also dropbar#18
M.dropbar = {
  DropBarKindArray = { link = "DropBarIconKindArray" },
  DropBarKindBoolean = { link = "DropBarIconKindBoolean" },
  DropBarKindBreakStatement = { link = "DropBarIconKindBreakStatement" },
  DropBarKindCall = { link = "DropBarIconKindCall" },
  DropBarKindCaseStatement = { link = "DropBarIconKindCaseStatement" },
  DropBarKindClass = { link = "DropBarIconKindClass" },
  DropBarKindConstant = { link = "DropBarIconKindConstant" },
  DropBarKindConstructor = { link = "DropBarIconKindConstructor" },
  DropBarKindContinueStatement = { link = "DropBarIconKindContinueStatement" },
  DropBarKindDeclaration = { link = "DropBarIconKindDeclaration" },
  DropBarKindDelete = { link = "DropBarIconKindDelete" },
  DropBarKindDoStatement = { link = "DropBarIconKindDoStatement" },
  DropBarKindElseStatement = { link = "DropBarIconKindElseStatement" },
  DropBarKindEnum = { link = "DropBarIconKindEnum" },
  DropBarKindEnumMember = { link = "DropBarIconKindEnumMember" },
  DropBarKindEvent = { link = "DropBarIconKindEvent" },
  DropBarKindField = { link = "DropBarIconKindField" },
  DropBarKindFile = { link = "DropBarIconKindFile" },
  DropBarKindFolder = { link = "DropBarIconKindFolder" },
  DropBarKindForStatement = { link = "DropBarIconKindForStatement" },
  DropBarKindFunction = { link = "DropBarIconKindFunction" },
  DropBarKindIdentifier = { link = "DropBarIconKindIdentifier" },
  DropBarKindIfStatement = { link = "DropBarIconKindIfStatement" },
  DropBarKindInterface = { link = "DropBarIconKindInterface" },
  DropBarKindKeyword = { link = "DropBarIconKindKeyword" },
  DropBarKindList = { link = "DropBarIconKindList" },
  DropBarKindMacro = { link = "DropBarIconKindMacro" },
  DropBarKindMarkdownH1 = { link = "DropBarIconKindMarkdownH1" },
  DropBarKindMarkdownH2 = { link = "DropBarIconKindMarkdownH2" },
  DropBarKindMarkdownH3 = { link = "DropBarIconKindMarkdownH3" },
  DropBarKindMarkdownH4 = { link = "DropBarIconKindMarkdownH4" },
  DropBarKindMarkdownH5 = { link = "DropBarIconKindMarkdownH5" },
  DropBarKindMarkdownH6 = { link = "DropBarIconKindMarkdownH6" },
  DropBarKindMethod = { link = "DropBarIconKindMethod" },
  DropBarKindModule = { link = "DropBarIconKindModule" },
  DropBarKindNamespace = { link = "DropBarIconKindNamespace" },
  DropBarKindNull = { link = "DropBarIconKindNull" },
  DropBarKindNumber = { link = "DropBarIconKindNumber" },
  DropBarKindObject = { link = "DropBarIconKindObject" },
  DropBarKindOperator = { link = "DropBarIconKindOperator" },
  DropBarKindPackage = { link = "DropBarIconKindPackage" },
  DropBarKindProperty = { link = "DropBarIconKindProperty" },
  DropBarKindReference = { link = "DropBarIconKindReference" },
  DropBarKindRepeat = { link = "DropBarIconKindRepeat" },
  DropBarKindScope = { link = "DropBarIconKindScope" },
  DropBarKindSpecifier = { link = "DropBarIconKindSpecifier" },
  DropBarKindStatement = { link = "DropBarIconKindStatement" },
  DropBarKindString = { link = "DropBarIconKindString" },
  DropBarKindStruct = { link = "DropBarIconKindStruct" },
  DropBarKindSwitchStatement = { link = "DropBarIconKindSwitchStatement" },
  DropBarKindType = { link = "DropBarIconKindType" },
  DropBarKindTypeParameter = { link = "DropBarIconKindTypeParameter" },
  DropBarKindUnit = { link = "DropBarIconKindUnit" },
  DropBarKindValue = { link = "DropBarIconKindValue" },
  DropBarKindVariable = { link = "DropBarIconKindVariable" },
  DropBarKindWhileStatement = { link = "DropBarIconKindWhileStatement" },
}

M.dropbar_overrides = {
  DropBarKindFile = { link = "Comment" },
  DropBarKindFolder = { link = "Comment" },

  -- By default, dropbar is highlighted as `WinBarNC` on inactive windows
  WinBarNC = { link = "Comment" },
}

M.dropbar_custom = vim.tbl_extend("force", M.dropbar, M.dropbar_overrides)

return M
