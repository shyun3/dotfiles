local JJ_DELTA_OPTS = "--no-pager --stat --git --color=always"

-- Derived from https://idursun.github.io/jjui/lua-cookbook/#open-diff-in-an-external-viewer
local function delta_rev()
  local change_id = context.change_id()
  assert(change_id and change_id ~= "", "No revision selected")

  local cmd = string.format(
    "jj show %q %s | delta --paging=always",
    change_id,
    JJ_DELTA_OPTS
  )
  exec_shell(cmd)
end

local function delta_file()
  local change_id = context.change_id()
  assert(change_id and change_id ~= "", "No revision selected")

  local file = context.file()
  assert(file and file ~= "", "No file selected")

  local cmd = string.format(
    "jj diff -r %q %q %s | delta --paging=always",
    change_id,
    file,
    JJ_DELTA_OPTS
  )
  exec_shell(cmd)
end

local function delta_evolog()
  local commit_id = context.commit_id()
  assert(commit_id and commit_id ~= "", "No revision selected")

  local cmd = string.format(
    "jj evolog -r %q -n 1 -G %s | delta --paging=always",
    commit_id,
    JJ_DELTA_OPTS
  )
  exec_shell(cmd)
end

---@diagnostic disable-next-line: lowercase-global
function setup(config)
  config.action("revisions.diff", delta_rev)
  config.action("revisions.details.diff", delta_file)
  config.action("revisions.evolog.diff", delta_evolog)
end
