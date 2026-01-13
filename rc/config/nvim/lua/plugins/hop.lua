---@alias FtKey "f" | "F" | "t" | "T"

--- Signature for hop's `get_input_pattern`
---@alias InputPatternGetter fun(prompt: string, maxchar: number?, opts: Options?): string?

local S = {
  ---@type FtKey?
  last_ft_key = nil,

  ---@type string?
  last_ft_char = nil,
}

--- Retrieve f/t specific hop options
---
---@param key FtKey
---
---@return table<FtKey, Options>
local function ft_opts(key)
  local hop_hint = require("hop.hint")
  local opts = {
    f = {
      direction = hop_hint.HintDirection.AFTER_CURSOR,
      current_line_only = true,
    },
    F = {
      direction = hop_hint.HintDirection.BEFORE_CURSOR,
      current_line_only = true,
    },
    t = {
      direction = hop_hint.HintDirection.AFTER_CURSOR,
      current_line_only = true,
      hint_offset = -1,
    },
    T = {
      direction = hop_hint.HintDirection.BEFORE_CURSOR,
      current_line_only = true,
      hint_offset = 1,
    },
  }

  return opts[key]
end

--- Same as private `override_opts` in `hop`, but does not check options
---
---@param opts Options
---
---@return Options
local function override_opts(opts)
  return setmetatable(opts or {}, { __index = require("hop").opts })
end

--- f/t hop specific `get_input_pattern`
---
---@param key FtKey
---@param maxchar number?
---@param opts Options?
---@param get_input_pattern InputPatternGetter? Uses default if nil
---
---@return string?
local function get_ft_input_pattern(key, maxchar, opts, get_input_pattern)
  if get_input_pattern == nil then
    get_input_pattern = require("hop").get_input_pattern
  end

  local input = get_input_pattern("", maxchar, opts)
  if input then
    S.last_ft_key = key
    S.last_ft_char = input
  end

  return input
end

--- Creates a function for f/t hop
---
---@param key FtKey
---
---@return fun()
local function make_hop_ft(key)
  return function()
    local last_get_input_pattern = require("hop").get_input_pattern

    ---@diagnostic disable-next-line: duplicate-set-field
    require("hop").get_input_pattern = function(_, ...)
      local maxchar, opts = ...
      return get_ft_input_pattern(key, maxchar, opts, last_get_input_pattern)
    end

    require("hop").hint_char1(ft_opts(key))
    require("hop").get_input_pattern = last_get_input_pattern
  end
end

--- Creates an expression function for f/t hop
---
--- Useful in operator expression mappings, as they support dot repeat. Default
--- hop dot repeat behavior prompts the user for a target again. This
--- implementation saves the target so that a dot repeat will only request a
--- specific jump target.
---
--- Technique derived from mini.jump
---
---@param key FtKey
---
---@return fun(): string
local function make_expr_hop_ft(key)
  return function()
    local target = get_ft_input_pattern(key, 1)

    -- Note the `v` before the command. Otherwise, the last character in a line
    -- can't be hopped to. See issue #85 and pull request #98.
    return target
        and string.format(
          "v<Cmd>lua hop_ft([=[%s]=], [=[%s]=])<CR>",
          key,
          target
        )
      or "<Esc>"
  end
end

--- Performs 1-character hop
---
--- This is global to allow use in expression mappings. Intended for
--- operator-pending mode.
---
---@param target string Single character to hop to
---@param opts Options?
function _G.hop_char1(target, opts)
  -- Gather any typed characters remaining in the input stream. These may be
  -- present when dot repeating a 'c' operation with a hop. This is necessary
  -- to prevent these keys from being fed to any hop char prompts that are
  -- invoked below.
  local chars = {}
  local input
  while input ~= "" do
    input = vim.fn.getcharstr(0)
    table.insert(chars, input)
  end

  -- Taken from `hop.hint_char1`
  opts = override_opts(opts or {})
  require("hop").hint_with_regex(
    require("hop.jump_regex").regex_by_case_searching(target, true, opts),
    opts
  )

  -- Now that any hop char prompts are finished, play the keys that were
  -- collected above
  local keys = table.concat(chars)
  vim.api.nvim_feedkeys(keys, "n", false)
end

--- Performs f/t hop
---
--- This is global to allow use in expression mappings. Intended for
--- operator-pending mode.
---
---@param key FtKey
---@param target string
function _G.hop_ft(key, target) hop_char1(target, ft_opts(key)) end

return {
  {
    "smoka7/hop.nvim",

    config = function()
      local hop = require("hop")
      hop.setup()

      local hopped = false
      local orig_hint_with_callback = hop.hint_with_callback

      --- Same as `hint_with_callback` except it resets any operator mode forced
      --- motion if a hop was executed. Using this workaround is needed otherwise
      --- the operator will still apply on the current cursor or line if motion
      --- is forced, even though the hop gets cancelled. Of course, this assumes
      --- that the hop uses this function.
      ---
      ---@diagnostic disable-next-line:duplicate-set-field
      hop.hint_with_callback = function(...)
        orig_hint_with_callback(...)
        if not hopped then require("util").reset_forced_motion() end
        hopped = false
      end

      local orig_move_cursor_to = hop.move_cursor_to

      --- Same as `move_cursor_to` but records if a hop was executed. Of course,
      --- this assumes that the hop uses this function.
      ---
      ---@diagnostic disable-next-line:duplicate-set-field
      hop.move_cursor_to = function(...)
        orig_move_cursor_to(...)
        hopped = true
      end

      -- To fix hop#114
      require("hop.jump_target").move_jump_target =
        require("util.hop").move_jump_target

      local orig_get_input_pattern = require("hop").get_input_pattern

      --- Same as `get_input_pattern` but blinks the cursor while waiting for
      --- input pattern and suppresses the prompt message.
      ---
      ---@diagnostic disable-next-line: duplicate-set-field
      require("hop").get_input_pattern = function(_, ...)
        local last_guicursor = vim.o.guicursor
        vim.o.guicursor =
          "n-v:block-blinkon500-blinkoff500,o:hor20-blinkon500-blinkoff500"

        local input = orig_get_input_pattern("", ...)
        vim.o.guicursor = last_guicursor

        return input
      end
    end,

    keys = {
      -- See `:h forced-motion` for usages of `v` and `V` in operator pending mode
      {
        "<Space>",
        "<Cmd>HopWord<CR>",
        mode = { "n", "x" },
        desc = "Hop to word",
      },
      {
        "<Space>",
        "v<Cmd>HopWord<CR>",
        mode = "o",
        desc = "Hop to word",
      },

      {
        "<Enter>",
        "<Cmd>HopChar1<CR>",
        mode = { "n", "x" },
        desc = "Hop to character",
      },
      {
        "<Enter>",

        function()
          local target = require("hop").get_input_pattern("", 1)

          -- Note the `v` before the command. Otherwise, the last character in
          -- a line can't be hopped to. See issue #85 and pull request #98.
          return target
              and string.format("v<Cmd>lua hop_char1([=[%s]=])<CR>", target)
            or "<Esc>"
        end,

        mode = "o",
        expr = true,
        desc = "Hop to character",
      },

      {
        "+",
        require("util.hop").hintTill1,
        mode = { "n", "x" },
        desc = "Hop till character",
      },
      {
        "+",
        "v<Cmd>lua require('util.hop').hintTill1()<CR>",
        mode = "o",
        desc = "Hop till character",
      },

      {
        "_",
        require("util.hop").hintLines,
        mode = { "n", "x" },
        desc = "Hop to line",
      },
      {
        "_",
        "V<Cmd>lua require('util.hop').hintLines()<CR>",
        mode = "o",
        desc = "Hop to line",
      },

      {
        "f",
        make_hop_ft("f"),
        mode = { "n", "x" },
        desc = "Hop: Enhanced f",
      },
      {
        "f",
        make_expr_hop_ft("f"),
        mode = "o",
        expr = true,
        desc = "Hop: Enhanced f",
      },

      {
        "F",
        make_hop_ft("F"),
        mode = { "n", "x" },
        desc = "Hop: Enhanced F",
      },
      {
        "F",
        make_expr_hop_ft("F"),
        mode = "o",
        expr = true,
        desc = "Hop: Enhanced F",
      },

      {
        "t",
        make_hop_ft("t"),
        mode = { "n", "x" },
        desc = "Hop: Enhanced t",
      },
      {
        "t",
        make_expr_hop_ft("t"),
        mode = "o",
        expr = true,
        desc = "Hop: Enhanced t",
      },

      {
        "T",
        make_hop_ft("T"),
        mode = { "n", "x" },
        desc = "Hop: Enhanced T",
      },
      {
        "T",
        make_expr_hop_ft("T"),
        mode = "o",
        expr = true,
        desc = "Hop: Enhanced T",
      },

      {
        ";",

        function()
          if S.last_ft_key and S.last_ft_char then
            return S.last_ft_key .. S.last_ft_char
          end
        end,

        mode = { "n", "x", "o" },
        expr = true,
        silent = true,
        desc = "Next f/t/F/T",
      },

      {
        ",",

        function()
          if S.last_ft_key and S.last_ft_char then
            local key = vim.fn.tr(S.last_ft_key, "ftFT", "FTft")
            return key .. S.last_ft_char
          end
        end,

        mode = { "n", "x", "o" },
        expr = true,
        silent = true,
        desc = "Previous f/t/F/T",
      },
    },
  },
}
