vim.filetype.add({
  extension = {
    h = function()
      if vim.fn.search("\\C^#include <[^>.]\\+>$", "nw") ~= 0 then
        return "cpp"
      end
      return "c"
    end,

    lds = "ld",
    S = "asm",
    xaml = "xml",
  },

  filename = {
    [".clang-format"] = "yaml",
    [".ignore"] = "gitignore",
    ["meson.format"] = "cfg",
    ["mise.lock"] = "toml",
  },

  pattern = {
    ["mise%..*%.lock"] = "toml",
  },
})
