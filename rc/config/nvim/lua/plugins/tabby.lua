---@module 'tabby'

local colors = require("util.colors").molokai

---@type table<string, TabbyHighlight>
local theme = {
  current = { fg = colors.black, bg = colors.yellow },
  modified = { fg = colors.black, bg = colors.blue },
  inactive = { fg = colors.light_black, bg = colors.gray },
}

---@param tab TabbyTab
---
---@return TabbyHighlight
local function get_tab_highlight(tab)
  local curr_hl = tab.current_win().buf().is_changed() and theme.modified
    or theme.current
  return tab.is_current() and curr_hl or theme.inactive
end

---@param tab TabbyTab
---@param next_tab? TabbyTab Tab of next higher number compared to `tab`
---
---@return TabbyNode
local function make_sep(tab, next_tab)
  local curr_tab_sep = {
    "",
    hl = { fg = get_tab_highlight(tab).bg, bg = theme.inactive.bg },
  }
  if tab.is_current() then return curr_tab_sep end

  local inactive_tab_sep = { "", hl = theme.inactive }
  if not next_tab then return inactive_tab_sep end

  local before_curr_tab_sep = {
    "",
    hl = { fg = theme.inactive.bg, bg = get_tab_highlight(next_tab).bg },
  }
  return next_tab.is_current() and before_curr_tab_sep or inactive_tab_sep
end

---@return TabbyNode
local function make_tab_count()
  return {
    { "", hl = { fg = theme.modified.bg, bg = theme.inactive.bg } },

    -- Note the space at the end. Margin doesn't seem to get added for the
    -- final node.
    string.format("tab %d/%d ", vim.fn.tabpagenr(), vim.fn.tabpagenr("$")),

    hl = theme.modified,
    margin = " ",
  }
end

return {
  "nanozuki/tabby.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "UIEnter",

  opts = {
    line = function(line)
      local all_tabs = line.tabs()

      local tab_from_num = {}
      all_tabs.foreach(function(tab) tab_from_num[tab.number()] = tab end)

      return {
        all_tabs.foreach(function(tab)
          local curr_win = tab.current_win()
          return {
            "", -- Needed for margin to be added
            tab.number(),
            tab.name(),
            curr_win.buf().is_changed() and "+" or curr_win.file_icon(),
            make_sep(tab, tab_from_num[tab.number() + 1]),

            hl = get_tab_highlight(tab),
            margin = " ",
          }
        end),
        line.spacer(),
        #all_tabs.tabs > 1 and make_tab_count() or "",

        hl = theme.inactive,
      }
    end,

    option = {
      tab_name = {
        name_fallback = function(tab_id)
          local win = require("tabby.feature.wins").new_win(
            vim.api.nvim_tabpage_get_win(tab_id),
            {}
          )

          local buf_id = win.buf().id
          local proj_name = vim.b[buf_id].title -- From vim-project
          if proj_name then return proj_name end

          if vim.bo[buf_id].filetype == "oil" then
            local raw_buf_name = vim.api.nvim_buf_get_name(buf_id)
            local path =
              vim.fn.fnamemodify(require("util").oil_filter(raw_buf_name), ":~")
            return #path < 20 and path or vim.fn.pathshorten(path)
          else
            -- Not an oil path
            return win.buf_name()
          end
        end,

        override = function(tab_id)
          local win_id = vim.api.nvim_tabpage_get_win(tab_id)
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          local buf_name = vim.api.nvim_buf_get_name(buf_id)

          if vim.startswith(buf_name, "health://") then
            return "[Health]"
          elseif vim.api.nvim_win_get_config(win_id).relative ~= "" then
            -- Window is floating, see `floating-windows`
            return "[Floating]"
          end
        end,
      },
    },
  },
}
