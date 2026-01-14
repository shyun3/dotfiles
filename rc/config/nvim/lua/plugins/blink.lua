return {
  { "shyun3/blink-cmp-ctags", lazy = true },
  { "onsails/lspkind.nvim", lazy = true },

  {
    LazyDep("blink.cmp"),
    version = "1.*",

    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
      keymap = {
        preset = "enter",

        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },

        ["<C-j>"] = { "snippet_forward", "fallback_to_mappings" },
        ["<C-k>"] = { "snippet_backward", "fallback_to_mappings" },
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
                  return map[name] or ""
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

      cmdline = {
        keymap = {
          ["<Left>"] = false,
          ["<Right>"] = false,
        },
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
  },
}
