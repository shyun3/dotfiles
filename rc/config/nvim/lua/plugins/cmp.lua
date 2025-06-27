return {
  "hrsh7th/nvim-cmp",
  enabled = false,

  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "folke/lazydev.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "quangnguyen30192/cmp-nvim-tags",
    "hrsh7th/cmp-omni",
  },

  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },

      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "lazydev" },
        { name = "nvim_lsp" },
        { name = "tags" },
        { name = "path" },
        { name = "omni" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              -- All buffers
              return vim.api.nvim_list_bufs()
            end,
          },
        },
      }),

      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = require("lspkind").cmp_format({
          menu = {
            luasnip = "[LS]",
            lazydev = "[LD]",
            nvim_lsp = "[LSP]",
            tags = "[T]",
            path = "[P]",
            buffer = "[B]",
            cmdline = "[CMD]",
            omni = "[O]",
          },
        }),
      },
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
