return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "master",
  event = "ModeChanged",

  main = "nvim-treesitter.configs",

  opts = {
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = false,
      },

      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist

        goto_next_start = {
          ["]m"] = { query = "@function.outer", desc = "Next function start" },
          ["]]"] = { query = "@class.outer", desc = "Next class start" },
        },
        goto_next_end = {
          ["]M"] = { query = "@function.outer", desc = "Next function end" },
          ["]["] = { query = "@class.outer", desc = "Next class end" },
        },
        goto_previous_start = {
          ["[m"] = {
            query = "@function.outer",
            desc = "Previous function start",
          },
          ["[["] = { query = "@class.outer", desc = "Previous class start" },
        },
        goto_previous_end = {
          ["[M"] = {
            query = "@function.outer",
            desc = "Previous function end",
          },
          ["[]"] = { query = "@class.outer", desc = "Previous class end" },
        },
      },
    },
  },
}
