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
---@param all_tabs TabbyTabs
---
---@return TabbyNode
local function make_sep(tab, all_tabs)
  local curr_tab_sep = {
    "",
    hl = { fg = get_tab_highlight(tab).bg, bg = theme.inactive.bg },
  }
  if tab.is_current() then return curr_tab_sep end

  local next_tab = all_tabs.filter(
    function(tab_) return tab_.number() == tab.number() + 1 end
  ).tabs[1]

  local inactive_tab_sep = { "", hl = theme.inactive }
  if not next_tab then return inactive_tab_sep end

  local before_curr_tab_sep = {
    "",
    hl = { fg = theme.inactive.bg, bg = get_tab_highlight(next_tab).bg },
  }
  return next_tab.is_current() and before_curr_tab_sep or inactive_tab_sep
end

return {
  "nanozuki/tabby.nvim",

  opts = {
    line = function(line)
      local all_tabs = line.tabs()

      return {
        all_tabs.foreach(function(tab)
          return {
            "", -- Needed for margin to be added
            tab.number(),
            tab.name(),
            make_sep(tab, all_tabs),

            hl = get_tab_highlight(tab),
            margin = " ",
          }
        end),
        line.spacer(),
        hl = theme.inactive,
      }
    end,
  },
}
