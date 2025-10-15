return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    preset = "modern",

    spec = {
      { "K", desc = "LSP: Hover" },
      { "Y", desc = "Yank to end of line" },
      { "&", desc = "Repeat last substitute with flags" },
      { "<C-l>", desc = "Clear and redraw screen" },

      { "gq", mode = { "n", "x" }, desc = "Custom format lines" },
      { "gri", desc = "Implementations" },
      { "grr", desc = "References" },
      { "gO", desc = "Show outline" },

      { "[a", desc = "Edit previous file in argument list" },
      { "[b", desc = "Go to previous buffer in buffer list" },
      { "[l", desc = "Location: Display previous error" },
      { "[L", desc = "Location: Display first error" },
      { "[q", desc = "Quickfix: Display previous error" },
      { "[A", desc = "Edit first file in argument list" },
      { "[B", desc = "Go to first buffer in buffer list" },
      { "[Q", desc = "Quickfix: Display first error" },
      { "[t", desc = "Jump to previous matching tag" },
      { "[T", desc = "Jump to first matching tag" },
      { "[<C-l>", desc = "Location: Display last error in previous file" },
      { "[<C-q>", desc = "Quickfix: Display last error in previous file" },
      { "[<C-t>", desc = "Jump to previous matching tag in preview window" },

      { "]a", desc = "Edit next file in argument list" },
      { "]b", desc = "Go to next buffer in buffer list" },
      { "]l", desc = "Location: Display next error" },
      { "]L", desc = "Location: Display last error" },
      { "]A", desc = "Edit last file in argument list" },
      { "]B", desc = "Go to last buffer in buffer list" },
      { "]q", desc = "Quickfix: Display next error" },
      { "]Q", desc = "Quickfix: Display last error" },
      { "]t", desc = "Jump to next matching tag" },
      { "]T", desc = "Jump to last matching tag" },
      { "]<C-l>", desc = "Location: Display first error in next file" },
      { "]<C-q>", desc = "Quickfix: Display first error in next file" },
      { "]<C-t>", desc = "Jump to next matching tag in preview window" },

      -- Insert mode
      { "<C-u>", mode = "i", desc = "Delete characters before cursor" },
      { "<C-w>", mode = "i", desc = "Delete word before cursor" },

      -- Visual mode
      {
        "Q",
        mode = "x",
        desc = "Linewise only: Repeat last recorded register for each line",
      },
      {
        "@",
        mode = "x",
        desc = "Linewise only: Execute register contents for each line",
      },
      { "a%", mode = "x", desc = "Matching group" },

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
    },
  },

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
  end,

  keys = {
    { "<Leader>?", "<Cmd>WhichKey<CR>", desc = "which-key: Show mappings" },
    { "<C-q>", mode = { "i", "v", "c", "o" } },
  },
}
