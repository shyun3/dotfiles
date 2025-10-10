return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = { preset = "modern" },

  config = function(_, opts)
    require("which-key").setup(opts)

    for _, mode in pairs({ "i", "s", "x", "c", "o" }) do
      vim.keymap.set(
        mode,
        "<C-q>",
        function() require("which-key").show({ mode = mode }) end,
        { desc = "which-key: Show mappings" }
      )
    end

    require("which-key").add({
      { "gq", mode = { "n", "x" }, desc = "Custom format lines" },

      -- Open tags in splits
      { "<A-]>", desc = "Tag" },
      {
        "<A-]>s",
        "<Cmd>wincmd g<C-]><CR>",
        desc = "Tag: Open definition in horizontal split",
      },
      {
        "<A-]>v",
        "<Cmd>vertical wincmd g<C-]><CR>",
        desc = "Tag: Open definition in vertical split",
      },

      -- Close windows
      { "<Leader>q", desc = "Close window" },
      {
        "<Leader>qq",
        "<Cmd>cclose<CR>",
        desc = "Close quickfix window",
      },
      {
        "<Leader>qh",
        "<Cmd>helpclose<CR>",
        desc = "Close one help window",
      },
    })
  end,

  keys = {
    { "<Leader>?", "<Cmd>WhichKey<CR>", desc = "which-key: Show mappings" },
    { "<C-q>", mode = { "i", "v", "c", "o" } },
  },
}
