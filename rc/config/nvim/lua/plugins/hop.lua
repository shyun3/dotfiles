return {
  "smoka7/hop.nvim",

  config = function()
    require("hop").setup()
    local hopped

    -- Same as `hint_with_callback` except it resets any operator mode forced
    -- motion if a hop was executed. Using this workaround is needed otherwise
    -- the operator will still apply on the current cursor or line if motion is
    -- forced, even though the hop gets cancelled. Of course, this assumes that
    -- the hop uses this function.
    local orig_hint_with_callback = require("hop").hint_with_callback

    ---@diagnostic disable-next-line:duplicate-set-field
    require("hop").hint_with_callback = function(...)
      orig_hint_with_callback(...)
      if not hopped then require("util").reset_forced_motion() end
      hopped = false
    end

    -- Same as `move_cursor_to` but records if a hop was executed. Of course,
    -- this assumes that the hop uses this function.
    local orig_move_cursor_to = require("hop").move_cursor_to

    ---@diagnostic disable-next-line:duplicate-set-field
    require("hop").move_cursor_to = function(...)
      orig_move_cursor_to(...)
      hopped = true
    end
  end,

  keys = {
    { "<Space>", "<Cmd>HopWord<CR>", mode = { "n", "x", "o" } },
    { "<Enter>", "<Cmd>HopChar1<CR>", mode = { "n", "x", "o" } },

    -- See `:h forced-motion` for usages of `v` and `V` in operator pending mode
    {
      "+",
      require("util.hop_hints").hintTill1,
      mode = { "n", "x" },
      desc = "Hop till character",
    },
    {
      "+",
      "v<Cmd>lua require('util.hop_hints').hintTill1()<CR>",
      mode = "o",
      desc = "Hop till character",
    },

    {
      "_",
      require("util.hop_hints").hintLines,
      mode = { "n", "x" },
      desc = "Hop to line",
    },
    {
      "_",
      "V<Cmd>lua require('util.hop_hints').hintLines()<CR>",
      mode = "o",
      desc = "Hop to line",
    },

    { "f", "<Cmd>HopChar1CurrentLineAC<CR>", mode = { "n", "x", "o" } },
    { "F", "<Cmd>HopChar1CurrentLineBC<CR>", mode = { "n", "x", "o" } },

    {
      "t",

      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end,

      mode = { "n", "x", "o" },
    },
    {
      "T",

      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end,

      mode = { "n", "x", "o" },
    },
  },
}
