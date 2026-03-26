return {
  {
    LazyDep("blink.cmp"),
    optional = true,

    opts = {
      completion = {
        menu = {
          draw = {
            components = {
              -- Taken from https://cmp.saghen.dev/recipes#icons
              -- See "nvim-web-devicons + lspkind"
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ =
                      require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then icon = dev_icon end
                  else
                    icon = require("lspkind").symbol_map[ctx.kind] or ""
                  end

                  return icon .. ctx.icon_gap
                end,

                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl =
                      require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then hl = dev_hl end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },
    },
  },

  { "onsails/lspkind.nvim", lazy = true },
}
