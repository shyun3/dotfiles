local M = { column_limit = 80 }

-- Derived from ctrlp#normcmd()
function M.go_to_editable_window()
  local invalidBufTypes = { "quickfix", "help", "nofile", "terminal" }
  if not vim.tbl_contains(invalidBufTypes, vim.bo.buftype) then return end

  local editWins = vim.tbl_filter(
    function(winNum)
      local buf = vim.fn.winbufnr(winNum)
      return not vim.list_contains(invalidBufTypes, vim.bo[buf].buftype)
    end,
    vim.tbl_map(vim.api.nvim_win_get_number, vim.api.nvim_tabpage_list_wins(0))
  )

  local tmpWin
  for _, winNum in ipairs(editWins) do
    local bufNum = vim.fn.winbufnr(winNum)
    if vim.fn.bufname(bufNum) == "" and vim.bo[bufNum].filetype == "" then
      tmpWin = winNum
      break
    end
  end

  local cwd = vim.fn.getcwd()
  if #editWins > 0 then
    if not vim.list_contains(editWins, vim.fn.winnr()) then
      vim.cmd((tmpWin or editWins[1]) .. "wincmd w")
    end
  else
    vim.cmd("botright vnew")
  end

  vim.cmd.lcd(cwd)
end

function M.reset_forced_motion()
  if vim.startswith(vim.fn.mode(1), "no") then
    -- Using `:normal` or `feedkeys` with `x` will reset forced motion (see
    -- vim#9332).
    vim.api.nvim_feedkeys("", "x", true)

    -- Exit operator pending mode
    vim.api.nvim_feedkeys([[\<Esc>]], "n", true)
  end
end

function M.replace_termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Translates paths opened in oil.nvim. Other paths are passed through
-- unmodified.
function M.oil_filter(path)
  local prefix = "oil://"
  return vim.startswith(path, prefix) and string.sub(path, #prefix + 1, -1)
    or path
end

function M.link_hl(name, link) vim.api.nvim_set_hl(0, name, { link = link }) end

return M
