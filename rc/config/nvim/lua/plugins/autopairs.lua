-- Derived from rules/basic.lua
local function quote_creator(opt)
  local Rule = require("nvim-autopairs.rule")
  local cond = require("nvim-autopairs.conds")

  local quote = function(...)
    local move_func = opt.enable_moveright and cond.move_right or cond.none
    ---@type Rule
    local rule = Rule(...)
      :with_move(move_func())
      :with_pair(cond.not_add_quote_inside_quote())

    if #opt.ignored_next_char > 1 then
      rule:with_pair(cond.not_after_regex(opt.ignored_next_char))
    end
    rule:use_undo(opt.break_undo)
    return rule
  end

  return quote
end

local function bracket_creator(opt)
  local cond = require("nvim-autopairs.conds")
  local quote = quote_creator(opt)

  local bracket = function(...)
    local rule = quote(...)
    if opt.enable_check_bracket_line == true then
      rule
        :with_pair(cond.is_bracket_line())
        :with_move(cond.is_bracket_line_move())
    end
    if opt.enable_bracket_in_quote then
      -- still add bracket if text is quote "|" and next_char have "
      rule:with_pair(cond.is_bracket_in_quote(), 1)
    end
    return rule
  end

  return bracket
end

return {
  {
    LazyDep("vim-endwise"),
    optional = true,

    -- Endwise wraps <CR> with its own mapping on startup by default, so make
    -- sure any autopairs plugins perform their mappings first
    dependencies = LazyDep("nvim-autopairs"),
  },

  {
    LazyDep("nvim-autopairs"),
    event = "InsertEnter",

    opts_extend = { "_my_custom_rules" },

    opts = {
      _my_custom_rules = {
        function(autopairs)
          -- Derived from Python rules, see rules/basic.lua
          return {
            autopairs
              .rule("'''", "'''", "meson")
              :with_pair(autopairs.conds.not_before_char("'", 3)),
            autopairs
              .quote("'", "'", "meson")
              :with_pair(function(opts)
                local str =
                  autopairs.utils.text_sub_char(opts.line, opts.col - 1, 1)
                return str == "f"
              end)
              :with_pair(autopairs.conds.not_before_regex("%w")),
          }
        end,
      },
    },

    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      local custom_rules = opts._my_custom_rules or {}
      for _, gen_rules in ipairs(custom_rules) do
        autopairs.add_rules(gen_rules({
          rule = require("nvim-autopairs.rule"),
          conds = require("nvim-autopairs.conds"),
          quote = quote_creator(autopairs.config),
          bracket = bracket_creator(autopairs.config),
          utils = require("nvim-autopairs.utils"),
        }))
      end
    end,
  },
}
