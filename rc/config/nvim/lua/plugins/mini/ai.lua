--- See `MiniAi-glossary`
---@alias ComposedPatternElem string | string[] | ComposedPatternElem[]
---@alias ComposedPattern ComposedPatternElem[]
---
---@alias RegionPosition {line: integer, col: integer, vis_mode: "v" | "V" | "\22" | nil}
---
---@class Region
---@field from RegionPosition
---@field to? RegionPosition

--- See `config.search_method`
---@alias SearchMethod
---| "cover"
---| "cover_or_next"
---| "cover_or_prev"
---| "cover_or_nearest"
---| "next"
---| "prev"
---| "nearest"

--- See 'MiniAi.find_textobject()'
---@class FindTextObjectOpts
---@field n_lines? integer Default: `config.n_lines`
---@field n_times? integer Default: 1
---@field reference_region? Region Default: empty region at cursor position
---@field search_method? SearchMethod Default: `config.search_method`

--- See `MiniAi-textobject-specification`
---@alias TextObjectSpecPatternElem ComposedPatternElem | fun(line: integer, init: integer): [integer, integer]?
---@alias CallableTextObjectSpec fun(ai_type: "a" | "i", id: string, opts: FindTextObjectOpts?): ComposedPattern | Region | Region[]
---@alias TextObjectSpec TextObjectSpecPatternElem[] | CallableTextObjectSpec

--- See `MiniAi.gen_spec.treesitter`
---@class TreesitterAiCaptures
---@field a string | string[] Captures for `a` text objects (should start with "@")
---@field i string | string[] Captures for `i` text objects

--- Helper for creating a treesitter text object specification
---
---@param ai_captures TreesitterAiCaptures
---@param fallback TextObjectSpec?
local function spec_treesitter(ai_captures, fallback)
  return function(ai_type)
    local ts_spec = require("mini.ai").gen_spec.treesitter(ai_captures)
    local ok, ts_region = pcall(ts_spec, ai_type)
    return ok and not vim.tbl_isempty(ts_region) and ts_region or fallback
  end
end

local builtin_key_descs = {
  b = ")]} block",
  q = [["'` string]],
  ["?"] = "User prompt",
}

local custom_key_descs = {
  a = "Argument",
  f = "Function call",
  k = "Treesitter: Class",
  F = "Treesitter: Function",
  S = "Treesitter: String",
  [";"] = "Treesitter: Block",
  g = "Whole buffer",
  i = "Indent level",
  L = "Line",
}

return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = function(_, opts)
      if opts.spec == nil then opts.spec = {} end

      local key_descs =
        vim.tbl_extend("error", builtin_key_descs, custom_key_descs)
      for key, desc in pairs(key_descs) do
        for _, prefix in pairs({ "a", "i" }) do
          table.insert(opts.spec, {
            prefix .. key,
            mode = { "o", "x" },
            desc = desc,
          })
        end
      end
    end,
  },

  { "echasnovski/mini.extra", lazy = true, version = false, config = true },

  {
    "echasnovski/mini.ai",
    version = false, -- Main branch

    event = "ModeChanged",

    opts = function()
      local gen_spec = require("mini.ai").gen_spec
      local gen_ai_spec = require("mini.extra").gen_ai_spec

      return {
        n_lines = 1000,
        search_method = "cover",

        custom_textobjects = {
          -- Restore built-ins, as they are not limited by the number of lines
          -- to search as configured by this plugin
          --
          -- Note that built-in quotes and backticks are not being used as the
          -- mini.ai versions work across line breaks
          ["("] = false,
          [")"] = false,
          ["["] = false,
          ["]"] = false,
          ["{"] = false,
          ["}"] = false,
          ["<"] = false,
          [">"] = false,
          t = false,

          a = spec_treesitter(
            { a = "@parameter.outer", i = "@parameter.inner" },
            gen_spec.argument()
          ),

          f = spec_treesitter(
            { a = "@call.outer", i = "@call.inner" },
            gen_spec.function_call()
          ),

          k = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
          F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          S = spec_treesitter({ a = "@string.outer", i = "@string.inner" }),
          [";"] = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),

          -- Whole buffer
          g = function(ai_type)
            return vim.tbl_extend(
              "error",
              gen_ai_spec.buffer()(ai_type),
              { vis_mode = "V" } -- Force linewise
            )
          end,

          i = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
        },
      }
    end,

    config = function(_, opts)
      require("mini.ai").setup(opts)

      for key, spec in pairs(opts.custom_textobjects) do
        if spec ~= false and not custom_key_descs[key] then
          vim.notify(
            "mini.ai: No description found for key " .. key,
            vim.log.levels.WARN
          )
        end
      end

      for key, _ in pairs(custom_key_descs) do
        if not opts.custom_textobjects[key] then
          vim.notify(
            "mini.ai: Description found for unspecified key " .. key,
            vim.log.levels.WARN
          )
        end
      end
    end,
  },
}
