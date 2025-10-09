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

-- Same as `hop.jump_target.move_jump_target` but fixes hop#114
function M.move_jump_target(jt, offset_row, offset_cell)
  local drow = offset_row or 0
  local dcell = offset_cell or 0

  if drow ~= 0 then
    ---@type WindowRow
    local new_row = jt.cursor.row + drow
    local max_row = vim.api.nvim_buf_line_count(jt.buffer)
    if new_row > max_row then
      jt.cursor.row = max_row
    elseif new_row < 1 then
      jt.cursor.row = 1
    else
      jt.cursor.row = new_row
    end
  end

  if dcell ~= 0 then
    local line = vim.api.nvim_buf_get_lines(
      jt.buffer,
      jt.cursor.row - 1,
      jt.cursor.row,
      false
    )[1]

    -- See https://github.com/smoka7/hop.nvim/issues/114#issuecomment-3387276393
    local last_ts = vim.bo.tabstop
    vim.bo.tabstop = 1

    local line_cells = vim.fn.strdisplaywidth(line)
    ---@type WindowCell
    local new_cell = vim.fn.strdisplaywidth(line:sub(1, jt.cursor.col)) + dcell
    if new_cell >= line_cells then
      new_cell = line_cells
    elseif new_cell < 0 then
      new_cell = 0
    end
    jt.cursor.col =
      vim.fn.byteidx(line, require("hop.window").cell2char(line, new_cell))

    vim.bo.tabstop = last_ts
  end
end

return M
