return {
  "glts/vim-textobj-comment",
  dependencies = "kana/vim-textobj-user",

  event = "ModeChanged",

  config = function()
    local key_descs = {
      c = "Comment",
      C = "Comment with surrounding whitespace",
    }
    for key, desc in pairs(key_descs) do
      for _, prefix in pairs({ "a", "i" }) do
        require("which-key").add({
          prefix .. key,
          mode = { "o", "x" },
          desc = desc,
        })
      end
    end
  end,
}
