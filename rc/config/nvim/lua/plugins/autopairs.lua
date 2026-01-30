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

      local basic_rules = require("nvim-autopairs.rules.basic")

      local custom_rules = opts._my_custom_rules or {}
      for _, gen_rules in ipairs(custom_rules) do
        autopairs.add_rules(gen_rules({
          rule = require("nvim-autopairs.rule"),
          conds = require("nvim-autopairs.conds"),
          quote = basic_rules.quote_creator(autopairs.config),
          bracket = basic_rules.bracket_creator(autopairs.config),
          utils = require("nvim-autopairs.utils"),
        }))
      end
    end,
  },
}
