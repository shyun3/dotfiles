return {
  "shyun3/vim-asterisk",
  branch = "personal",

  init = function() vim.g["asterisk#keeppos"] = 1 end,

  keys = {
    {
      "*",
      "<Plug>(asterisk-*)",
      desc = "Search forward for whole word",
    },
    {
      "*",
      "<Plug>(asterisk-*)",
      mode = "x",
      desc = "Search forward for selection",
    },
    {
      "#",
      "<Plug>(asterisk-#)",
      desc = "Search backward for whole word",
    },
    {
      "#",
      "<Plug>(asterisk-#)",
      mode = "x",
      desc = "Search backward for selection",
    },
    {
      "g*",
      "<Plug>(asterisk-g*)",
      desc = "Search forward for word",
    },
    {
      "g#",
      "<Plug>(asterisk-g#)",
      desc = "Search backward for word",
    },
    {
      "z*",
      "<Plug>(asterisk-z*)",
      desc = "Highlight all occurrences of whole word, set direction forward",
    },
    {
      "z*",
      "<Plug>(asterisk-z*)",
      mode = "x",
      desc = "Highlight all occurrences of selection, set direction forward",
    },
    {
      "gz*",
      "<Plug>(asterisk-gz*)",
      desc = "Highlight all occurrences of word, set direction forward",
    },
    {
      "z#",
      "<Plug>(asterisk-z#)",
      desc = "Highlight all occurrences of whole word, set direction backward",
    },
    {
      "z#",
      "<Plug>(asterisk-z#)",
      mode = "x",
      desc = "Highlight all occurrences of selection, set direction backward",
    },
    {
      "gz#",
      "<Plug>(asterisk-gz#)",
      desc = "Highlight all occurrences of word, set direction backward",
    },
  },
}
