; extends

; Taken from https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/807#issuecomment-3318666949
(string
  (string_start)
  _* @string.inner
  (string_end)) @string.outer
