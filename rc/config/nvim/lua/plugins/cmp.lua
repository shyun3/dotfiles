local function link_hl(name, link) vim.api.nvim_set_hl(0, name, { link = link }) end

local function highlight_cmp_menu()
  -- Some colors taken from:
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu

  link_hl("CmpItemAbbrDeprecated", "@lsp.mod.deprecated")

  -- Taken from CocSearch
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#15aabf" })
  link_hl("CmpItemAbbrMatchFuzzy", "CmpIntemAbbrMatch")

  -- Taken from CocMenuSel
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#13354A" })

  -- gray
  vim.api.nvim_set_hl(0, "CmpItemMenu", { bg = "NONE", fg = "#808080" })

  link_hl("CmpItemKindFunction", "@lsp.type.function")
  link_hl("CmpItemKindMethod", "@lsp.type.method")
  link_hl("CmpItemKindConstructor", "CmpItemKindMethod")

  link_hl("CmpItemKindText", "String")

  link_hl("CmpItemKindProperty", "@lsp.type.property")
  link_hl("CmpItemKindField", "CmpItemKindProperty")

  link_hl("CmpItemKindVariable", "@lsp.type.variable")
  link_hl("CmpItemKindTypeParameter", "@lsp.type.parameter")
  link_hl("CmpItemKindReference", "CmpItemKindVariable")

  link_hl("CmpItemKindClass", "@lsp.type.class")
  link_hl("CmpItemKindStruct", "@lsp.type.struct")
  link_hl("CmpItemKindInterface", "@lsp.type.interface")
  link_hl("CmpItemKindEnum", "@lsp.type.enum")

  link_hl("CmpItemKindKeyword", "@lsp.type.keyword")
  link_hl("CmpItemKindOperator", "@lsp.type.operator")

  -- front
  vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { bg = "NONE", fg = "#D4D4D4" })

  link_hl("CmpItemKindModule", "@lsp.type.namespace")

  -- pink
  vim.api.nvim_set_hl(0, "CmpItemKindFile", { bg = "NONE", fg = "#C586C0" })
  link_hl("CmpItemKindFolder", "CmpItemKindFile")

  link_hl("CmpItemKindEnumMember", "@lsp.type.enumMember")
  link_hl("CmpItemKindConstant", "CmpItemKindEnumMember")

  link_hl("CmpItemKindEvent", "@lsp.type.event")
end

return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },

  dependencies = {
    "windwp/nvim-autopairs", -- To make sure <CR> gets mapped first
    "tpope/vim-endwise",

    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "quangnguyen30192/cmp-nvim-ultisnips",
    "folke/lazydev.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "quangnguyen30192/cmp-nvim-tags",

    "onsails/lspkind.nvim",
  },

  config = function()
    highlight_cmp_menu()

    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<CR>"] = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ select = false })
          else
            fallback()
            vim.fn.feedkeys(
              require("util").replace_termcodes("<Plug>DiscretionaryEnd")
            )
          end
        end,

        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),

        ["<C-Space>"] = cmp.mapping.complete(),
      }),

      sources = cmp.config.sources({
        { name = "ultisnips" },
        { name = "lazydev" },
        { name = "nvim_lsp" },
        { name = "tags" },
        { name = "path" },
        {
          name = "buffer",
          option = {
            -- Visible buffers
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
      }),

      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = require("lspkind").cmp_format({
          menu = {
            ultisnips = "[US]",
            lazydev = "[LD]",
            nvim_lsp = "[LSP]",
            tags = "[T]",
            path = "[P]",
            buffer = "[B]",
            cmdline = "[CMD]",
          },
        }),
      },

      experimental = { ghost_text = true },
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
