-- C syntax highlighting
vim.g.c_gnu = 1
vim.g.c_no_curly_error = 1

-- Python
vim.g.python3_host_prog = "~/.pyenv/versions/neovim/bin/python3"

-- Clipboard
-- Derived from https://github.com/neovim/neovim/issues/10223#issuecomment-703544303
if vim.fn.exists("$DISPLAY") then
  vim.g.clipboard = {
    name = "xclip with ^M Trim",
    copy = {
      ["+"] = "xclip -i -sel clip",
      ["*"] = "xclip -i",
    },
    paste = {
      ["+"] = function()
        return vim.fn.systemlist(
          'xclip -o -sel clip -r -t UTF8_STRING 2>/dev/null | sed -e "s/\r$//"',
          "",
          1
        )
      end,
      ["*"] = function()
        return vim.fn.systemlist(
          'xclip -o -r -t UTF8_STRING 2>/dev/null | sed -e "s/\r$//"',
          "",
          1
        )
      end,
    },
  }
end
