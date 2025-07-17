return {
  "kana/vim-textobj-user", -- Must be loaded before all vim-textobj plugins

  { "glts/vim-textobj-comment", event = "ModeChanged" },
  { "kana/vim-textobj-entire", event = "ModeChanged" },
  { "kana/vim-textobj-indent", event = "ModeChanged" },
}
