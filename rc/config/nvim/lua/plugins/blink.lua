local function link_hl(name, link) vim.api.nvim_set_hl(0, name, { link = link }) end

local function highlight_cmp_menu()
  -- Some colors taken from:
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu

  link_hl("BlinkCmpLabelDeprecated", "@lsp.mod.deprecated")

  -- Taken from CocSearch
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#15aabf" })

  -- Taken from CocMenuSel
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#13354A" })

  -- gray
  vim.api.nvim_set_hl(0, "BlinkCmpSource", { bg = "NONE", fg = "#808080" })

  link_hl("BlinkCmpKindFunction", "@lsp.type.function")
  link_hl("BlinkCmpKindMethod", "@lsp.type.method")
  link_hl("BlinkCmpKindConstructor", "BlinkCmpKindMethod")

  link_hl("BlinkCmpKindText", "String")

  link_hl("BlinkCmpKindProperty", "@lsp.type.property")
  link_hl("BlinkCmpKindField", "BlinkCmpKindProperty")

  link_hl("BlinkCmpKindVariable", "@lsp.type.variable")
  link_hl("BlinkCmpKindTypeParameter", "@lsp.type.parameter")
  link_hl("BlinkCmpKindReference", "BlinkCmpKindVariable")

  link_hl("BlinkCmpKindClass", "@lsp.type.class")
  link_hl("BlinkCmpKindStruct", "@lsp.type.struct")
  link_hl("BlinkCmpKindInterface", "@lsp.type.interface")
  link_hl("BlinkCmpKindEnum", "@lsp.type.enum")

  link_hl("BlinkCmpKindKeyword", "@lsp.type.keyword")
  link_hl("BlinkCmpKindOperator", "@lsp.type.operator")

  -- front
  vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { bg = "NONE", fg = "#D4D4D4" })

  link_hl("BlinkCmpKindModule", "@lsp.type.namespace")

  -- pink
  vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { bg = "NONE", fg = "#C586C0" })
  link_hl("BlinkCmpKindFolder", "BlinkCmpKindFile")

  link_hl("BlinkCmpKindEnumMember", "@lsp.type.enumMember")
  link_hl("BlinkCmpKindConstant", "BlinkCmpKindEnumMember")

  link_hl("BlinkCmpKindEvent", "@lsp.type.event")
end

return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = "onsails/lspkind.nvim",
  event = { "InsertEnter", "CmdlineEnter" },

  opts = {
    keymap = { preset = "enter" },

    completion = {
      list = { selection = { preselect = false } },

      menu = {
        -- nvim-cmp style menu
        -- Derived from https://cmp.saghen.dev/configuration/general.html
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
            { "source_name" },
          },

          components = {
            -- Derived from https://cmp.saghen.dev/recipes#nvim-web-devicons-lspkind
            kind_icon = {
              text = function(ctx)
                return require("lspkind").symbolic(
                  ctx.kind,
                  { mode = "symbol" }
                ) .. ctx.icon_gap
              end,
            },

            source_name = {
              text = function(ctx)
                local name = string.lower(ctx.source_name)
                local map = {
                  lsp = "[LSP]",
                  path = "[P]",
                  snippets = "[SNIP]",
                  buffer = "[B]",
                }
                return vim.tbl_get(map, name) or ""
              end,
            },
          },
        },
      },

      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    snippets = { preset = "luasnip" },
  },

  config = function(_, opts)
    highlight_cmp_menu()

    require("blink.cmp").setup(opts)
  end,
}
