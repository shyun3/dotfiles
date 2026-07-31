local function zshellcheck(_, lines)
  local out = {}
  for _, line in ipairs(lines) do
    local lnum, col, severity, msg =
      line:match("^[^:]+:(%d+):(%d+):%s+([^:]+):%s+(.+)$")

    local type
    if severity == "error" then
      type = "E"
    elseif severity == "warning" then
      type = "W"
    elseif severity == "info" then
      type = "I"
    elseif severity == "style" then
      type = "I"
    end

    if lnum then
      table.insert(out, {
        text = msg,
        lnum = lnum,
        col = col,
        type = type,
      })
    end
  end

  return out
end

local function zshellcheck_fix(_)
  return {
    command = "zshellcheck -no-color -fix %t",
    read_temporary_file = 1,
  }
end

return {
  "dense-analysis/ale",
  ft = "zsh",

  init = function()
    -- See `ale-lint-settings-on-startup`
    vim.g.ale_echo_cursor = 0
    vim.g.ale_hover_cursor = 0
  end,

  opts = {
    linters_explicit = true,
    history_enabled = 0,

    linter_aliases = {
      -- By default, zsh is aliased to sh
      zsh = "zsh",
    },

    linters = {
      zsh = { "zshellcheck" },
    },

    fixers = {
      zsh = { zshellcheck_fix },
    },
  },

  config = function(_, opts)
    require("ale").setup(opts)

    vim.fn["ale#linter#Define"]("zsh", {
      name = "zshellcheck",
      callback = zshellcheck,
      executable = "zshellcheck",
      command = "zshellcheck -no-color %t",
    })
  end,
}
