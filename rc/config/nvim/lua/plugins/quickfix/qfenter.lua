--- @alias QfTabWinFunc
--- | "QFEnter#GetTabWinNR_Open"
--- | "QFEnter#GetTabWinNR_VOpen"
--- | "QFEnter#GetTabWinNR_HOpen"
--- | "QFEnter#GetTabWinNR_TOpen"

--- @alias QfOpenCmd "cc" | "cn" | "cp"

--- @class QfCmdSpec
--- @field tabwinfunc QfTabWinFunc
--- @field qfopencmd QfOpenCmd
--- @field keepfocus boolean

--- Taken from plugin/QFEnter.vim
local cmd_action_map = {
  vopen = {
    tabwinfunc = "QFEnter#GetTabWinNR_VOpen",
    qfopencmd = "cc",
    keepfocus = false,
  },
  hopen = {
    tabwinfunc = "QFEnter#GetTabWinNR_HOpen",
    qfopencmd = "cc",
    keepfocus = false,
  },
}

--- @param cmd_spec QfCmdSpec
local function make_qfenter_cmd(cmd_spec)
  return function()
    vim.fn["QFEnter#OpenQFItem"](
      cmd_spec.tabwinfunc,
      cmd_spec.qfopencmd,
      cmd_spec.keepfocus and 1 or 0,
      0
    )
  end
end

return {
  "yssl/QFEnter",

  init = function()
    vim.g.qfenter_keymap = {
      open = {},
      vopen = {},
      hopen = {},
      topen = {},
    }
  end,

  keys = {
    {
      "<C-s>",
      make_qfenter_cmd(cmd_action_map.hopen),
      ft = "qf",
      desc = "Open item in horizontal split",
    },
    {
      "<C-v>",
      make_qfenter_cmd(cmd_action_map.vopen),
      ft = "qf",
      desc = "Open item in vertical split",
    },
  },
}
