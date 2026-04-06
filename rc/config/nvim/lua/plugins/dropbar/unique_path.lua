-- dropbar source that is like `path`, but yields paths that are unique for all
-- windows open in the current tab

local S = {
  is_init = false,
  resolver = nil, ---@type FileNameResolver
}

---@param bufnr integer
---
---@return string
local function get_norm_path(bufnr)
  return vim.fs.normalize(
    require("util.path").normalize(vim.api.nvim_buf_get_name(bufnr))
  )
end

---@param winid integer
---
---@return boolean
local function is_not_float_win(winid)
  return vim.api.nvim_win_get_config(winid).relative == ""
end

---@param tabid integer 0 for current tabpage
---
---@return integer[] Window IDs
local function get_tab_wins(tabid)
  local wins = vim.api.nvim_tabpage_list_wins(tabid)
  return vim.tbl_filter(is_not_float_win, wins)
end

-- Derived from tabby *win_name.lua* and *buf_name.lua*
local function init()
  S.resolver = require("util.file_name_resolver"):new({
    get_name = get_norm_path,

    get_names = function()
      local win_ids = vim.tbl_filter(
        function(winid) return vim.wo[winid].winbar ~= "" end,
        get_tab_wins(0)
      )

      local names = {}
      for _, winid in ipairs(win_ids) do
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if not names[bufnr] then names[bufnr] = get_norm_path(bufnr) end
      end

      return names
    end,
  })

  vim.api.nvim_create_autocmd({
    "WinNew",
    "WinClosed",
    "BufWinEnter",
    "BufWinLeave",
    "BufDelete",
    "TabLeave",
  }, {
    group = vim.api.nvim_create_augroup("my_dropbar_unique_path", {}),
    desc = "Flush file name resolver",
    callback = function() S.resolver:flush() end,
  })
end

---@param bufnr integer
---
---@return dropbar_symbol_t[]
local function make_symbols(bufnr)
  local path = get_norm_path(bufnr)
  if path == "" then return {} end

  local uniq_path = S.resolver:get_name(bufnr, "unique")
  if uniq_path == "" then return {} end

  local configs = require("dropbar.configs")
  local sym = require("dropbar.bar").dropbar_symbol_t
  local icon_kinds = configs.opts.icons.kinds

  local parts = {}
  local dirname = vim.fs.dirname(uniq_path)
  if dirname ~= "." then
    local icon, icon_hl = configs.eval(icon_kinds.dir_icon, dirname)
    parts[#parts + 1] = sym:new({
      name = dirname,
      name_hl = "DropBarKindDir",
      icon = icon,
      icon_hl = icon_hl,
    })
  end

  local basename = vim.fs.basename(uniq_path)
  if basename ~= "" then
    local stat = vim.uv.fs_stat(path)
    local is_dir = stat and stat.type == "directory"

    local icon, icon_hl =
      configs.eval(is_dir and icon_kinds.dir_icon or icon_kinds.file_icon, path)

    parts[#parts + 1] = sym:new({
      name = basename,
      name_hl = is_dir and "DropBarKindDir" or "DropBarKindFile",
      icon = icon,
      icon_hl = icon_hl,
    })
  end

  return parts
end

--- Derived from path and LSP sources
---
---@param bufnr integer
---@param winid integer
---
---@return dropbar_symbol_t[]
local function get_symbols(bufnr, winid)
  bufnr = vim._resolve_bufnr(bufnr)
  if
    not vim.api.nvim_buf_is_valid(bufnr)
    or not vim.api.nvim_win_is_valid(winid)
  then
    return {}
  end

  if not S.is_init then
    init()
    S.is_init = true
  end

  return make_symbols(bufnr)
end

return { get_symbols = get_symbols }
