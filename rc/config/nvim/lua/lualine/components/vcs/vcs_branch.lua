-- Derived from lualine "branch" component

---@class VcsBranch
---@field [1] string
---@field icon? string

local M = {}

local utils = require("lualine.utils.utils")

local S = {
  ---@type VcsBranch
  curr_branch = { "" },

  ---@type string?
  curr_vcs_dir = "",

  ---@type { [integer]: VcsBranch } bufnr -> branch
  branch_cache = {},

  active_bufnr = -1,
  head_file_watch = vim.uv.new_fs_event(),

  ---@type { [string]: string }
  ---  directory -> corresponding VCS directory (.git or .jj)
  vcs_dir_cache = {},
}

--- Checks if the given path if a .jj directory
---
--- Does not perform filesystem check
---
---@param dir string
---
---@return boolean
local function is_dir_jj(dir)
  local jj_dir = "/.jj"
  return dir:sub(-#jj_dir) == jj_dir
end

--- Reads the current jj branch asynchronously
---
---@param workspace_dir string jj workspace directory
---@param callback fun(branch: VcsBranch) Callback executed on read completion.
---  Branch name will be empty on error.
local function read_jj_branch(workspace_dir, callback)
  pcall(vim.system, {
    "jj",
    "prompt_log",
    "-R",
    workspace_dir,
    "-n",
    "2",
    "-r",
    "best_named_ancestor(@) | @",
    "--color",
    "never",
    "-T",
    -- Empty: U+ea7b
    [[
      join(
        ':',
        revision_symbol,
        coalesce(bookmarks, tags, change_id.shortest(6)),
        coalesce(
          prompt_symbols,
          if(empty, ''),
        )
      )
    ]] .. "++ '\n'",
  }, function(obj)
    if obj.code ~= 0 then
      callback({ "" })
      return
    end

    local lines = vim.split(obj.stdout, "\n")

    local curr_commit = lines[1]
    local _, _, sym = unpack(vim.split(curr_commit, ":"))

    local best_commit = lines[#lines - 1]
    local icon, refs, _ = unpack(vim.split(best_commit, ":"))
    callback({
      -- If multiple bookmarks/tags, grab only the first
      refs:gsub("%s.*", "") .. (sym ~= "" and " " .. vim.trim(sym) or ""),
      icon = icon ~= "" and vim.trim(icon) or "\u{f15c6}", -- 󱗆
    })
  end)
end

--- Reads Git branch or commit hash if detached HEAD
---
---@param head_file_path string Full path to .git/HEAD file
---
---@return VcsBranch
local function read_git_head(head_file_path)
  local head_file = io.open(head_file_path)
  if not head_file then return { "" } end

  local head = head_file:read()
  head_file:close()

  local branch = head:match("ref: refs/heads/(.+)$")
  return branch and {
    branch,
    icon = "\u{e0a0}", -- 
  } or {
    head:sub(1, 6),
    icon = "\u{f1d3} ", -- 
  }
end

-- Updates last saved branch and begins watch on VCS head file
local function update_branch()
  local bufnr = vim.api.nvim_get_current_buf()
  S.active_bufnr = bufnr
  S.head_file_watch:stop()

  ---@param branch VcsBranch
  local function save_branch(branch)
    S.curr_branch = branch
    S.branch_cache[bufnr] = branch
  end

  local vcs_dir = S.curr_vcs_dir
  local branch = S.curr_branch
  if vcs_dir and #vcs_dir > 0 then
    local head_file
    if is_dir_jj(vcs_dir) then
      head_file = vcs_dir .. "/working_copy/checkout"
      read_jj_branch(vim.fn.fnamemodify(vcs_dir, ":h"), save_branch)
    else
      head_file = vcs_dir .. "/HEAD"
      branch = read_git_head(head_file)
    end

    S.head_file_watch:start(head_file, {}, vim.schedule_wrap(update_branch))
  else
    branch = { "" }
  end

  save_branch(branch)
end

-- Updates last saved VCS directory and begins watch on VCS head file
local function update_vcs_dir(vcs_dir)
  if S.curr_vcs_dir ~= vcs_dir then
    S.curr_vcs_dir = vcs_dir
    update_branch()
  end
end

--- Determines the path to the Git directory from the given .git file/folder
---
--- Does not take into account GIT_DIR environment variable
---
---@param git_path string Full path to .git file or folder
---
---@return string? git_dir nil if argument was invalid
local function extract_git_dir(git_path)
  local git_file_stat = vim.uv.fs_stat(git_path)
  if not git_file_stat then return end

  local git_dir
  if git_file_stat.type == "directory" then
    git_dir = git_path
  elseif git_file_stat.type == "file" then
    -- Separate Git directory or submodule is used
    local git_file = io.open(git_path)
    if git_file then
      git_dir = git_file:read()
      git_dir = git_dir and git_dir:match("gitdir: (.+)$")
      git_file:close()
    end

    -- Submodule/relative file path
    if
      git_dir
      and git_dir:sub(1, 1) ~= "/"
      and not git_dir:match("^%a:.*$")
    then
      git_dir = git_path:match("(.*).git") .. git_dir
    end
  end

  if git_dir then
    local head_file_stat = vim.loop.fs_stat(git_dir .. "/HEAD")
    if head_file_stat and head_file_stat.type == "file" then return git_dir end
  end
end

-- Finds and saves full path to VCS directory based on current directory
function M.find_vcs_dir()
  local curr_file_dir = require("util.path").normalize(vim.fn.expand("%:p:h"))

  -- Extract correct file directory from terminals
  if curr_file_dir and curr_file_dir:match("term://.*") then
    curr_file_dir = vim.fn.expand(curr_file_dir:gsub("term://(.+)//.+", "%1"))
  end

  -- Git directory from environment is not cached
  local git_env_dir = vim.env.GIT_DIR

  -- Search upward for .jj directory or .git file/folder
  local root_dir = curr_file_dir
  local jj_dir
  local git_dir = git_env_dir
  while root_dir do
    local cache_dir = S.vcs_dir_cache[root_dir]
    if cache_dir then
      if is_dir_jj(cache_dir) then
        jj_dir = cache_dir
        break
      elseif not git_dir then
        git_dir = cache_dir
      end
    end

    local jj_probe_dir = root_dir .. "/.jj"
    local jj_stat = vim.uv.fs_stat(jj_probe_dir)
    if jj_stat and jj_stat.type == "directory" then
      jj_dir = jj_probe_dir
      break
    end

    if not git_dir then git_dir = extract_git_dir(root_dir .. "/.git") end

    root_dir = root_dir:match("(.*)/.-")
  end

  local vcs_dir = jj_dir or git_dir
  if jj_dir or not git_env_dir then S.vcs_dir_cache[curr_file_dir] = vcs_dir end

  update_vcs_dir(vcs_dir)
end

function M.init()
  -- Run watch head on load so branch is present when component is loaded
  M.find_vcs_dir()

  --- Update branch on BufEnter as different buffers may be on different repos
  ---@diagnostic disable-next-line: missing-parameter
  utils.define_autocmd(
    "BufEnter",
    "lua require'lualine.components.vcs.vcs_branch'.find_vcs_dir()"
  )
end

---@param bufnr integer?
function M.get_branch(bufnr)
  local actual_curbuf = vim.g.actual_curbuf
  if actual_curbuf ~= nil and S.active_bufnr ~= actual_curbuf then
    -- Workaround for #286, see upstream issue neovim#15300
    -- Diff is out of sync, resync it
    M.find_vcs_dir()
  end

  if bufnr then return S.branch_cache[bufnr] or "" end

  local curr_branch = S.curr_branch
  S.branch_cache[vim.api.nvim_get_current_buf()] = curr_branch

  return curr_branch
end

return M
