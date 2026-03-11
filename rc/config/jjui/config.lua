---@diagnostic disable: undefined-global, lowercase-global

-- Derived from https://idursun.github.io/jjui/lua-cookbook/#open-diff-in-an-external-viewer
local function delta_rev()
  local change_id = context.change_id()
  assert(change_id and change_id ~= "", "No revision selected")

  exec_shell(
    string.format(
      "jj show %q --no-pager --stat --git --color=always | delta --paging=always",
      change_id
    )
  )
end

local function delta_file()
  local change_id = context.change_id()
  assert(change_id and change_id ~= "", "No revision selected")

  local file = context.file()
  assert(file and file ~= "", "No file selected")

  exec_shell(
    string.format(
      "jj diff -r %q %q --no-pager --stat --git --color=always | delta --paging=always",
      change_id,
      file
    )
  )
end

local function delta_evolog()
  local commit_id = context.commit_id()
  assert(commit_id and commit_id ~= "", "No revision selected")

  exec_shell(
    string.format(
      "jj evolog -r %q -n 1 -G --no-pager --stat --git --color=always | delta --paging=always",
      commit_id
    )
  )
end

function setup(config)
  config.action("revisions.diff", delta_rev)

  config.action(
    "delta-file",
    delta_file,
    { key = "d", scope = "revisions.details", desc = "delta" }
  )

  config.action(
    "delta-evolog",
    delta_evolog,
    { key = "d", scope = "revisions.evolog", desc = "delta" }
  )
end
