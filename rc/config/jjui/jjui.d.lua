---@meta _

---@class FlashContent
---@field [1] string Text
---@field error boolean? Styles as error
---@field sticky boolean? Keeps message visible

context = {
  ---@return string
  commit_id = function() end,
}

diff = {
  ---@param content string
  show = function(content) end,
}

--- Runs a shell command line, yields until done
---
---@param cmd string
function exec_shell(cmd) end

--- Shows a short status message
---
---@param content string | FlashContent
function flash(content) end

--- Runs `jj` command synchronously
---
---@param ... string Arguments
---
---@return string? output
---@return string? err
function jj(...) end
