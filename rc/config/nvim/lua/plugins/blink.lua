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
                _my_text = {
                  -- If source name is not explicitly specified by the
                  -- provider, it is set to the capitalized provider ID
                  LSP = "[LSP]",
                  Path = "[P]",
                  Snippets = "[SNIP]",
                  Buffer = "[B]",
                  Omni = "[O]",
                  LazyDev = "[LD]",
                  Ctags = "[T]",
                },
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

      cmdline = {
        keymap = {
          ["<Left>"] = false,
          ["<Right>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          ghost_text = { enabled = false },
        },
      },
    },

    config = function(_, opts)
      local src_name = vim.tbl_get(
        opts,
        "completion",
        "menu",
        "draw",
        "components",
        "source_name"
      )
      if src_name then
        local my_text = src_name._my_text

        -- Clear, so that it doesn't fail blink's config validation
        src_name._my_text = nil

        if my_text then
          src_name.text = function(ctx) return my_text[ctx.source_name] or "" end
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
}
