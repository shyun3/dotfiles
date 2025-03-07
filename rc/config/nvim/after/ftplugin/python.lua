-- Pythonsense
if vim.b.pythonsense_is_tab_indented then
  vim.keymap.set(
    { "o", "v" },
    "ak",
    "<Plug>(PythonsenseOuterClassTextObject)",
    { buffer = true }
  )
  vim.keymap.set(
    { "o", "v" },
    "ik",
    "<Plug>(PythonsenseInnerClassTextObject)",
    { buffer = true }
  )

  vim.keymap.set(
    { "o", "v" },
    "af",
    "<Plug>(PythonsenseOuterFunctionTextObject)",
    { buffer = true }
  )
  vim.keymap.set(
    { "o", "v" },
    "if",
    "<Plug>(PythonsenseInnerFunctionTextObject)",
    { buffer = true }
  )

  vim.keymap.set(
    { "o", "v" },
    "ad",
    "<Plug>(PythonsenseOuterDocStringTextObject)",
    { buffer = true }
  )
  vim.keymap.set(
    { "o", "v" },
    "id",
    "<Plug>(PythonsenseInnerDocStringTextObject)",
    { buffer = true }
  )
end
