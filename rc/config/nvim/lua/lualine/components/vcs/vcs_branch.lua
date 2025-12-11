-- Derived from lualine "branch" component

local M = {}

local utils = require("lualine.utils.utils")

local S = {
  curr_branch = "",

  ---@type string?
  curr_vcs_dir = "",

  ---@type table<integer, string>
  branch_cache = {}, -- bufnr: branch

  active_bufnr = -1,
  head_file_watch = vim.uv.new_fs_event(),

  ---@type table<string, string>
  vcs_dir_cache = {}, -- directory: corresponding VCS directory
}

--- Reads and saves Git branch or commit hash if detached HEAD
---
---@param head_file_path string Full path to .git/HEAD file
local function read_git_head(head_file_path)
  local head_file = io.open(head_file_path)
  if not head_file then return end

  local head = head_file:read()
  head_file:close()

  local branch = head:match("ref: refs/heads/(.+)$")
  S.curr_branch = branch or head:sub(1, 6)
end

-- Updates last saved branch and begins watch on VCS head file
local function update_branch()
  local bufnr = vim.api.nvim_get_current_buf()
  S.active_bufnr = bufnr
  S.head_file_watch:stop()

  local vcs_dir = S.curr_vcs_dir
  if vcs_dir and #vcs_dir > 0 then
    local head_file = vcs_dir .. "/HEAD"
    read_git_head(head_file)

    S.head_file_watch:start(
      head_file,
      {},
      vim.schedule_wrap(function() update_branch() end)
    )
  else
    S.curr_branch = ""
  end

  S.branch_cache[bufnr] = S.curr_branch
end

-- Updates last saved VCS directory and begins watch on VCS head file
local function update_vcs_dir(vcs_dir)
  if S.curr_vcs_dir ~= vcs_dir then
    S.curr_vcs_dir = vcs_dir
    update_branch()
  end
end

-- Finds and saves full path to Git directory based on current directory
local function find_git_dir()
  local git_dir = vim.env.GIT_DIR
  if git_dir then
    update_vcs_dir(git_dir)
    return
  end

  local curr_file_dir = require("util").oil_filter(vim.fn.expand("%:p:h"))

  -- Extract correct file directory from terminals
  if curr_file_dir and curr_file_dir:match("term://.*") then
    curr_file_dir = vim.fn.expand(curr_file_dir:gsub("term://(.+)//.+", "%1"))
  end

  -- Search upward for .git file or folder
  local root_dir = curr_file_dir
  while root_dir do
    if S.vcs_dir_cache[root_dir] then
      git_dir = S.vcs_dir_cache[root_dir]
      break
    end

    local git_path = root_dir .. "/.git"
    local git_file_stat = vim.uv.fs_stat(git_path)
    if git_file_stat then
      if git_file_stat.type == "directory" then
        git_dir = git_path
      elseif git_file_stat.type == "file" then
        -- Separate Git directory or submodule is used
        local file = io.open(git_path)
        if file then
          git_dir = file:read()
          git_dir = git_dir and git_dir:match("gitdir: (.+)$")
          file:close()
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
        if head_file_stat and head_file_stat.type == "file" then
          break
        else
          git_dir = nil
        end
      end
    end

    root_dir = root_dir:match("(.*)/.-")
  end

  S.vcs_dir_cache[curr_file_dir] = git_dir
  update_vcs_dir(git_dir)
end

function M.find_vcs_dir() find_git_dir() end

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
