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
  dependencies = {
    "folke/lazydev.nvim",
    "shyun3/blink-cmp-ctags",

    "onsails/lspkind.nvim",
  },

  event = { "InsertEnter", "CmdlineEnter" },

  opts = {
    keymap = {
      preset = "enter",

      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },

      ["<C-j>"] = { "snippet_forward", "fallback_to_mappings" },
      ["<C-k>"] = { "snippet_backward", "fallback_to_mappings" },

      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },

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
                  omni = "[O]",
                  lazydev = "[LD]",
                  ctags = "[T]",
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
      default = { "lsp", "path", "snippets", "buffer", "omni", "ctags" },

      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },

      providers = {
        lsp = {
          -- Always show buffer source
          fallbacks = { "ctags" },
        },

        ctags = {
          name = "Ctags",
          module = "blink-cmp-ctags",

          opts = {
            tag_kinds_map = {
              ["4DGL"] = {
                c = vim.lsp.protocol.CompletionItemKind.Constant,
                d = vim.lsp.protocol.CompletionItemKind.Constant,
                f = vim.lsp.protocol.CompletionItemKind.Function,
                u = vim.lsp.protocol.CompletionItemKind.Constant,
                v = vim.lsp.protocol.CompletionItemKind.Variable,
              },
            },
          },
        },

        path = { fallbacks = {} },

        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },

        buffer = {
          -- Recommended in https://cmp.saghen.dev/configuration/reference#providers
          score_offset = -5,

          opts = {
            -- Gets all "normal" buffers
            -- Taken from https://cmp.saghen.dev/recipes#buffer-completion-from-all-open-buffers
            get_bufnrs = function()
              return vim.tbl_filter(
                function(bufnr) return vim.bo[bufnr].buftype == "" end,
                vim.api.nvim_list_bufs()
              )
            end,
          },
        },
      },
    },

    snippets = { preset = "luasnip" },

    signature = { enabled = true, window = { show_documentation = true } },

    cmdline = {
      completion = {
        list = { selection = { preselect = false } },

        menu = {
          auto_show = function()
            -- Don't show in grepper prompt
            return vim.tbl_contains({ ":", "/", "?" }, vim.fn.getcmdtype())
          end,
        },

        ghost_text = { enabled = false },
      },
    },
  },

  config = function(_, opts)
    highlight_cmp_menu()

    require("blink.cmp").setup(opts)
  end,
}
