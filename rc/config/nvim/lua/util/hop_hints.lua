local M = {}

local function move_cursor_till(jt)
  local jumpLine = jt.cursor.row
  local jumpCol = jt.cursor.col

  local curPos = vim.api.nvim_win_get_cursor(0)
  local row = curPos[1]
  local col = curPos[2]

  local hintOffset
  if row > jumpLine or (row == jumpLine and col > jumpCol) then
    hintOffset = 1
  else
    hintOffset = -1
  end

  local HintDirection = require("hop.hint").HintDirection
  require("hop").move_cursor_to(jt, {
    direction = hintOffset == 1 and HintDirection.AFTER_CURSOR
      or HintDirection.BEFORE_CURSOR,
    hint_offset = hintOffset,
  })
end

-- Like `hop.jump_regex.regex_by_line_start_skip_whitespace()` except it also
-- marks empty or whitespace only lines
local function regexLines()
  return {
    oneshot = true,
    match = function(str)
      return vim.regex([[\v(\S|.$)]]):match_str(str) or 0, 1
    end,
  }
end

-- Derived from `hop.hint_char1()`
function M.hintTill1()
  local hop = require("hop")
  local opts = hop.opts

  local c = hop.get_input_pattern("", 1)
  if not c then
    require("util").reset_forced_motion()
    return
  end

  hop.hint_with_regex(
    require("hop.jump_regex").regex_by_case_searching(c, true, opts),
    opts,
    move_cursor_till
  )
end

-- Like `:HopLineStart` except it also jumps to empty or whitespace only lines
function M.hintLines()
  require("hop").hint_with_regex(regexLines(), require("hop").opts)
end

return M
