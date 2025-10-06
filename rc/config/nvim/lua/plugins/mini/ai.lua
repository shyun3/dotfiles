--- See `MiniAi-glossary`
--- @alias ComposedPatternElem string | string[] | ComposedPatternElem[]
--- @alias ComposedPattern ComposedPatternElem[]
---
--- @alias RegionPosition {line: integer, col: integer, vis_mode: "v" | "V" | "\22" | nil}
---
--- @class Region
--- @field from RegionPosition
--- @field to? RegionPosition

--- See `config.search_method`
--- @alias SearchMethod
--- | "cover"
--- | "cover_or_next"
--- | "cover_or_prev"
--- | "cover_or_nearest"
--- | "next"
--- | "prev"
--- | "nearest"

--- See 'MiniAi.find_textobject()'
--- @class FindTextObjectOpts
--- @field n_lines? integer Default: `config.n_lines`
--- @field n_times? integer Default: 1
--- @field reference_region? Region Default: empty region at cursor position
--- @field search_method? SearchMethod Default: `config.search_method`

--- See `MiniAi-textobject-specification`
--- @alias TextObjectSpecPatternElem ComposedPatternElem | fun(line: integer, init: integer): [integer, integer]?
--- @alias CallableTextObjectSpec fun(ai_type: "a" | "i", id: string, opts: FindTextObjectOpts?): ComposedPattern | Region | Region[]
--- @alias TextObjectSpec TextObjectSpecPatternElem[] | CallableTextObjectSpec

--- See `MiniAi.gen_spec.treesitter`
--- @class TreesitterAiCaptures
--- @field a string | string[] Captures for `a` text objects (should start with "@")
--- @field i string | string[] Captures for `i` text objects

--- Helper for creating a treesitter text object specification
---
--- @param ai_captures TreesitterAiCaptures
--- @param fallback TextObjectSpec?
local function spec_treesitter(ai_captures, fallback)
  return function(ai_type)
    local ts_region = require("nvim-treesitter.parsers").has_parser()
        and require("mini.ai").gen_spec.treesitter(ai_captures)(ai_type)
      or {}
    return vim.tbl_isempty(ts_region) and fallback or ts_region
  end
end

return {
  { "echasnovski/mini.extra", lazy = true, version = false, config = true },

  {
    "echasnovski/mini.ai",
    version = false, -- Main branch

    event = "ModeChanged",

    config = function()
      local mini_ai = require("mini.ai")

      local gen_spec = mini_ai.gen_spec
      local gen_ai_spec = require("mini.extra").gen_ai_spec

      mini_ai.setup({
        custom_textobjects = {
          -- Restore built-ins, as they are not limited by the number of lines
          -- to search as configured by this plugin
          ["("] = false,
          [")"] = false,
          ["["] = false,
          ["]"] = false,
          ["{"] = false,
          ["}"] = false,
          ["<"] = false,
          [">"] = false,
          ['"'] = false,
          ["'"] = false,
          ["`"] = false,
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
        },

        mappings = {
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
        },

        search_method = "cover",
      })

      local key_descs = {
        b = ")]} block",
        q = [["'` string]],
        ["?"] = "User prompt",
        a = "Argument",
        f = "Function call",
        k = "Class",
        F = "Function",
        [";"] = "Treesitter block",
        g = "Whole buffer",
        i = "Indent level",
      }
      for key, desc in pairs(key_descs) do
        for _, prefix in pairs({ "a", "i" }) do
          require("which-key").add({
            {
              prefix .. key,
              mode = { "o", "x" },
              desc = desc,
            },
          })
        end
      end
    end,
  },
}
