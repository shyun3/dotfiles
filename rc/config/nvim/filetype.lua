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
    [".clangd"] = "yaml",
    [".clang-format"] = "yaml",
    [".gutctags"] = "ctags",
    [".gutentags"] = "tags",
    [".ignore"] = "gitignore",
  },
})
