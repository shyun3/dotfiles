return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",

  event = "ModeChanged",

  opts = {
    select = {
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = false,
    },
  },

  keys = function()
    local move = require("nvim-treesitter-textobjects.move")
    local modes = { "n", "x", "o" }
    local group = "textobjects"
    return {
      {
        "]m",
        function() move.goto_next_start("@function.outer", group) end,
        mode = modes,
        desc = "Next function start",
      },
      {
        "]]",
        function() move.goto_next_start("@class.outer", group) end,
        mode = modes,
        desc = "Next class start",
      },

      {
        "]M",
        function() move.goto_next_end("@function.outer", group) end,
        mode = modes,
        desc = "Next function end",
      },
      {
        "][",
        function() move.goto_next_end("@class.outer", group) end,
        mode = modes,
        desc = "Next class end",
      },

      {
        "[m",
        function() move.goto_previous_start("@function.outer", group) end,
        mode = modes,
        desc = "Previous function start",
      },
      {
        "[[",
        function() move.goto_previous_start("@class.outer", group) end,
        mode = modes,
        desc = "Previous class start",
      },

      {
        "[M",
        function() move.goto_previous_end("@function.outer", group) end,
        mode = modes,
        desc = "Previous function end",
      },
      {
        "[]",
        function() move.goto_previous_end("@class.outer", group) end,
        mode = modes,
        desc = "Previous class end",
      },
    }
  end,
}
