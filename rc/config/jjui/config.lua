local JJ_DELTA_OPTS = "--no-pager --stat --git --color=always"

--- Displays the output of a bash command in the diff panel
---
---@param cmd string
local function diff_show(cmd)
  local output, err = jj("util", "exec", "--", "bash", "-c", cmd)
  if output then
    diff.show(output)
  else
    flash({ err, error = true })
  end
end

local function delta_rev()
  local change_id = context.change_id()
  assert(change_id and change_id ~= "", "No revision selected")

  local cmd = string.format(
    "jj show %q %s | delta --paging=never",
    change_id,
    JJ_DELTA_OPTS
  )
  diff_show(cmd)
end

local function delta_file()
  local change_id = context.change_id()
  assert(change_id and change_id ~= "", "No revision selected")

  local file = context.file()
  assert(file and file ~= "", "No file selected")

  local cmd = string.format(
    "jj diff -r %q %q %s | delta --paging=never",
    change_id,
    file,
    JJ_DELTA_OPTS
  )
  diff_show(cmd)
end

local function delta_evolog()
  local commit_id = context.commit_id()
  assert(commit_id and commit_id ~= "", "No revision selected")

  local cmd = string.format(
    "jj evolog -r %q -n 1 -G %s | delta --paging=never",
    commit_id,
    JJ_DELTA_OPTS
  )
  diff_show(cmd)
end

---@diagnostic disable-next-line: lowercase-global
function setup(config)
  config.action("revisions.diff", delta_rev)
  config.action("revisions.details.diff", delta_file)
  config.action("revisions.evolog.diff", delta_evolog)
end
