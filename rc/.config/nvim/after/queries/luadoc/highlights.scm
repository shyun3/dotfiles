; extends

; Setting this to higher priority than semantic highlights to override some
; lua_ls quirks
([
  ; Opening bracket is highlighted, but not closing for some reason
  "["
  "]"
  "{"
  "}"
  ; Some colons get highlighted, but not others
  ":"
] @punctuation.bracket
  (#set! priority 130))
