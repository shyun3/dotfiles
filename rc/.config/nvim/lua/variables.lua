-- C syntax highlighting
vim.g.c_gnu = 1
vim.g.c_no_curly_error = 1

-- Clipboard
-- Derived from https://github.com/neovim/neovim/issues/10223#issuecomment-703544303
if vim.fn.exists("$WAYLAND_DISPLAY") then
  vim.g.clipboard = {
    name = "wl-clipboard with ^M Trim",
    copy = {
      ["+"] = "wl-copy --type text/plain",
      ["*"] = "wl-copy --type text/plain --primary",
    },
    paste = {
      ["+"] = function()
        return vim.fn.systemlist(
          'wl-paste --no-newline --type "text/plain;charset=utf-8" 2>/dev/null | sed -e "s/\r$//"',
          "",
          1
        )
      end,
      ["*"] = function()
        return vim.fn.systemlist(
          'wl-paste --no-newline --type "text/plain;charset=utf-8" --primary 2>/dev/null | sed -e "s/\r$//"',
          "",
          1
        )
      end,
    },
  }
end
