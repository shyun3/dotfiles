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

local function select_descendants()
  local parent = revisions.current()
  local last_change = parent

  revisions.jump_to_children()
  revisions.refresh() -- Also clears any selections

  local curr_change = revisions.current()
  while last_change ~= curr_change do
    -- Non-built-in toggle select jumps to parent afterward
    jjui.builtin.revisions.toggle_select()

    last_change = curr_change

    revisions.jump_to_children()
    revisions.refresh({ keep_selections = true })

    curr_change = revisions.current()
  end

  if curr_change ~= parent then
    revisions.jump_to_parent() -- Jumps over selected revisions
  end
end

local function copy_short_commit_hash()
  local id = context.change_id()
  if not id then return end

  local sha, err = jj(
    "log",
    "-r",
    id,
    "-n=1",
    "--no-graph",
    "--color=never",
    "-T=commit_id.shortest(7)"
  )
  if sha then
    copy_to_clipboard(sha)
    flash("Copied: " .. sha)
  elseif err then
    flash({
      text = err,
      error = true,
      sticky = true,
    })
  end
end

local function set_tag()
  local id = context.change_id()
  if not id then return end

  local tag_name = input({ title = "Enter tag name" })
  if not tag_name then return end

  local out, err = jj("tag", "set", "-r", id, tag_name)
  if out then
    -- No output actually seems to be returned

    -- Update UI to show newly added tag
    revisions.refresh({ keep_selections = true, selected_revision = id })
  elseif err then
    flash({ text = err, error = true, sticky = true })
  end
end

---@diagnostic disable-next-line: lowercase-global
function setup(config)
  config.action("revisions.diff", delta_rev)
  config.action("revisions.details.diff", delta_file)
  config.action("revisions.evolog.diff", delta_evolog)

  config.action("select-descendants", select_descendants, {
    key = "ctrl+space",
    scope = "revisions",
    desc = "select descendants",
  })

  config.action("copy-short-commit-hash", copy_short_commit_hash, {
    key = "Y",
    scope = "revisions",
    desc = "copy short commit hash",
  })

  config.action("set-tag", set_tag, {
    key = "T",
    scope = "revisions",
    desc = "set tag",
  })
end
