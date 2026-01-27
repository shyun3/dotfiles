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
    branch = "personal",

    event = "InsertEnter",

    opts_extend = { "_my_custom_rules" },

    opts = {},

    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      local rule = require("nvim-autopairs.rule")
      local conds = require("nvim-autopairs.conds")

      local custom_rules = opts._my_custom_rules or {}
      for _, gen_rules in ipairs(custom_rules) do
        autopairs.add_rules(gen_rules(rule, conds))
      end
    end,
  },
}
